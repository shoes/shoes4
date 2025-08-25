# Shoes4 on Apple Silicon (ARM64) Macs

This version of Shoes4 has been modernized to run natively on Apple Silicon Macs using ARM64 architecture.

## Prerequisites

- **JRuby 9.4.8.0** or later
- **Java 11+** (tested with Temurin 21)
- **macOS** on Apple Silicon (M1/M2/M3)

## Setup

1. **Install JRuby with RVM**:
   ```bash
   source ~/.rvm/scripts/rvm
   rvm install jruby-9.4.8.0
   rvm use jruby-9.4.8.0
   rvm gemset create shoes4
   rvm use jruby-9.4.8.0@shoes4
   ```

2. **Set Java Home** (if needed):
   ```bash
   export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home
   ```

3. **Install Dependencies**:
   ```bash
   gem install bundler
   bundle install
   ```

## Running Shoes Apps

Use the ARM64-native launcher:

```bash
bundle exec jruby -J-XstartOnFirstThread bin/shoes-arm64 <your_app.rb>
```

Example:
```bash
bundle exec jruby -J-XstartOnFirstThread bin/shoes-arm64 samples/simple_calc.rb
```

## What Changed

### Key Modernizations

1. **Glimmer DSL for SWT Integration**
   - Added `glimmer-dsl-swt` gem which includes ARM64-native SWT libraries
   - No more x86_64 emulation needed!

2. **Modern SWT Loader** (`shoes-swt/lib/shoes/swt_modern.rb`)
   - Automatically detects CPU architecture
   - Loads appropriate SWT jar (ARM64 for Apple Silicon)
   - Falls back to legacy SWT if modern version unavailable

3. **ARM64 Launcher** (`bin/shoes-arm64`)
   - Specifically configured for Apple Silicon Macs
   - Uses modern SWT loader

### Modified Files

- `Gemfile` - Added `glimmer-dsl-swt` dependency and `matrix` gem
- `shoes-swt/shoes-swt.gemspec` - Updated SWT version from 4.6.1.2 to 4.6.1.1

## Performance

Running natively on ARM64 provides:
- Faster startup times
- Better battery life
- No Rosetta 2 emulation overhead
- Native macOS integration

## Troubleshooting

If you see warnings about `enable_widget`, these can be safely ignored - they don't affect functionality.

## Sample Test App

Create a file `test.rb`:

```ruby
Shoes.app width: 400, height: 200, title: "ARM64 Native!" do
  background "#2E7D32".."#66BB6A"
  
  stack margin: 20 do
    title "Shoes4 on Apple Silicon!", stroke: white
    para "Running natively on ARM64", stroke: white
    
    button "Click Me!" do
      alert "Hello from native ARM64!"
    end
  end
end
```

Run with:
```bash
bundle exec jruby -J-XstartOnFirstThread bin/shoes-arm64 test.rb
```

Enjoy native performance on your Apple Silicon Mac!