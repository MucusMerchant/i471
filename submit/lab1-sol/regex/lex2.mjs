// Note JavaScript allow specifying regex literals within /.../ delimiters
export default {
  $Ignore: /\s+/,  // \s matches whitespace; \s+ matches one-or-more whitespace
                   // $Ignore means that any whitespace will be ignored.
  ID: /[a-zA-Z_][a-zA-Z0-9_]*/,
  INT: /\d+/,      // \d matches a digit, \d+ matches one-or-more digits for
                   // token with kind INT        
  CHAR: /./,       // single char: must be last;
                   // . is a regex which matches any char other than '\n'
//  ID: /[a-zA-Z_][a-zA-Z0-9_]*/,
};
