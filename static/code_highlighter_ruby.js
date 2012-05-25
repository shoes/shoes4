CodeHighlighter.addStyle("rb",{
	comment : {
		exp  : /#[^\n]+/
	},
	brackets : {
		exp  : /\(|\)|\{|\}/
	},
	string : {
		exp  : /'[^']*'|"[^"]*"/
	},
	keywords : {
		exp  : /\b(do|end|self|class|def|if|module|yield|then|else|for|until|unless|while|elsif|case|when|break|retry|redo|rescue|raise)\b/
	},
  constant : {
    exp  : /\b([A-Z]\w+)\b/
  },
  ivar : {
    exp  : /([^@])(@{1,2}\w+)\b/
  },
  ns   : {
    exp  : /(:{2,})/
  },
	symbol : {
	  exp : /(:[A-Za-z0-9_!?]+)/
	}
});
