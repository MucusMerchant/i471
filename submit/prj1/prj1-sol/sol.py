import re
import sys
import json

class Token:
    def __init__(self, kind, lexeme):
        self.kind = kind
        self.lexeme = lexeme

def lexer(text):
    tokens = []

    def step(t):
        if m := re.compile(r'\s+').match(t):
            return (m, None)
        elif m := re.compile(r'#.*').match(t):
            return (m, None)
        elif m := re.compile(r'%{').match(t):
            return (m, '%{')
        elif m := re.compile(r'}').match(t):
            return (m, '}')
        elif m := re.compile(r'\[').match(t):
            return (m, '[')
        elif m := re.compile(r'\]').match(t):
            return (m, ']')
        elif m := re.compile(r'{').match(t):
            return (m, '{')
        elif m := re.compile(r',').match(t):
            return (m, ',')
        elif m := re.compile(r'=>').match(t):
            return (m, '=>')
        elif m := re.compile(r'(true|false)\b').match(t):
            return (m, 'BOOLEAN')
        elif m := re.compile(r'\d+(_?\d+)*').match(t):
            return (m, 'INTEGER')
        elif m := re.compile(r':[A-Za-z_]\w*').match(t):
            return (m, 'ATOM') 
        elif m := re.compile(r'[A-Za-z_]\w*:').match(t):
            return (m, 'KEY')
        else:
            sys.exit(1)

    tokens = []
    while (len(text) > 0):
        match, kind = step(text)
        lexeme = match.group(0)
        if (kind):
            tokens.append(Token(kind, lexeme))
        text = text[len(lexeme):]
    return tokens


def parse(text):
    tokens = lexer(text)

    index = 0

    def peek(kind):
        return lookahead.kind == kind

    def consume(kind):
        nonlocal lookahead
        if lookahead.kind == kind:
            lookahead = nextToken()
        else:
            print(f'expecting {kind} at {lookahead.lexeme}',
                  file=sys.stderr)
            sys.exit(1)

    def nextToken():
        nonlocal index
        if index >= len(tokens):
            return Token('EOF', '<EOF>')
        tok = tokens[index]
        index += 1
        return tok

    def sentence():
        body = []
        while not peek('EOF'):
            body.append(data_literal())
        return body

    def data_literal():
        if peek('['):
            return list_()
        elif peek('{'):
            return tuple_()
        elif peek('%{'):
            return map_()
        else:
            return primitive()

    def primitive():
        if peek('INTEGER'):
            return integer()
        elif peek('BOOLEAN'):
            return boolean()
        elif peek('ATOM'):
            return atom()
        else:
            sys.exit(1)

    def list_():
        consume('[')
        elements = []

        if peek(']'):
            consume(']')
            return {
                "%k": "list",
                "%v": elements
            }

        elements.append(data_literal())
        while peek(','):
            consume(',')
            elements.append(data_literal())

        consume(']')
        return {
            "%k": "list",
            "%v": elements
        }

    def tuple_():
        consume('{')
        elements = []

        if peek('}'):
            consume('}')
            return {
                "%k": "tuple",
                "%v": elements
            }

        elements.append(data_literal())
        while peek(','):
            consume(',')
            elements.append(data_literal())

        consume('}')
        return {
            "%k": "tuple",
            "%v": elements
        }

    def map_():
        consume('%{')
        pairs = []

        if peek('}'):
            consume('}')
            return {
                "%k": "map",
                "%v": pairs
            }

        pairs.append(key_pair())
        while peek(','):
            consume(',')
            pairs.append(key_pair())

        consume('}')
        return {
            "%k": "map",
            "%v": pairs
        }

    def key_pair():
        if peek('KEY'):
            key_node = key()
        else:
            key_node = data_literal()
            consume('=>')
        value_node = data_literal()
        
        return [key_node, value_node]

    def integer():
        value = lookahead.lexeme
        consume('INTEGER')
        return {
            "%k": "int",
            "%v": int(value.replace('_', ''))
        }

    def atom():
        value = lookahead.lexeme
        consume('ATOM')
        return {
            "%k": "atom",
            "%v": value
        }

    def key():
        value = lookahead.lexeme
        consume('KEY')
        return {
            "%k": "atom",
            "%v": value[1:] + value[0]
        }

    def boolean():
        value = lookahead.lexeme
        consume('BOOLEAN')
        return {
            "%k": "bool",
            "%v": value == "true"
        }

    lookahead = nextToken()
    return sentence()

if __name__ == "__main__":
    text = sys.stdin.read()
    parsed_text = parse(text)
    print(json.dumps(parsed_text, separators=(',', ':')))

