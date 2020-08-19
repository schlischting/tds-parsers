{
  const keywordList = [
    "AFTER",
    "ALL",
    "AND",
    "ANY",
    "ASC",
    "ASCII",
    "ASCENDING",
    "AT",
    "ATTRIBUTE",
    "ATTRIBUTES",
    "AUTONEXT",
    "AVG",
    "BEFORE",
    "BEGIN",
    "BETWEEN",
    "BORDER",
    "BOTTOM",
    "BY",
    "CASE",
    "CLEAR",
    "CLIPPED",
    "CLOSE",
    "COLUMN",
    "COLUMNS",
    "COMMAND",
    "COMMENTS",
    "COMMIT",
    "CONSTRAINT",
    "CONSTRUCT",
    "CONTINUE",
    "COUNT",
    "CREATE",
    "CURRENT",
    "CURSOR",
    "DATABASE",
    "DECLARE",
    "DEFAULTS",
    "DEFER",
    "DELETE",
    "DELIMITERS",
    "DELIMITER",
    "DESC",
    "DESCENDING",
    "DIRTY",
    "DISTINCT",
    "DOWNSHIFT",
    "DROP",
    "ELSE",
    "ERROR",
    "EVERY",
    "EXCLUSIVE",
    "EXECUTE",
    "EXIT",
    "EXISTS",
    "EXTEND",
    "EXTERNAL",
    "FALSE",
    "FETCH",
    "FIELD",
    "FILE",
    "FINISH",
    "FIRST",
    "FLUSH",
    "FOR",
    "FOREACH",
    "FORM",
    "FORMAT",
    "FREE",
    "FROM",
    "GROUP",
    "HAVING",
    "HEADER",
    "HELP",
    "HIDE",
    "HOLD",
    "IF",
    "IN",
    "INCLUDE",
    "INDEX",
    "INITIALIZE",
    "INPUT",
    "INSERT",
    "INSTRUCTIONS",
    "INTERRUPT",
    "INTERVAL",
    "INTO",
    "IS",
    "ISOLATION",
    "KEY",
    "LABEL",
    "LAST",
    "LEFT",
    "LENGTH",
    "LINE",
    "LINES",
    "LOAD",
    "LOCK",
    "LOG",
    "MAIN",
    "MARGIN",
    "MATCHES",
    "MAX",
    "MDY",
    "MENU",
    "MESSAGE",
    "MIN",
    "MOD",
    "MODE",
    "NAME",
    "NEED",
    "NEXT",
    "NO",
    "NOENTRY",
    "NOT",
    "NOTFOUND",
    "NULL",
    "ON",
    "OPEN",
    "OPTION",
    "OPTIONS",
    "OR",
    "ORDER",
    "OTHERWISE",
    "OUTER",
    "OUTPUT",
    "PAGE",
    "PAGENO",
    "PIPE",
    "PREPARE",
    "PREVIOUS",
    "PRIMARY",
    "PRINT",
    "PROGRAM",
    "PROMPT",
    "PUT",
    "QUIT",
    "READ",
    "REPORT",
    "RETURN",
    "REVERSE",
    "RIGTH",
    "ROLLBACK",
    "ROW",
    "ROWS",
    "RUN",
    "SCREEN",
    "SCROLL",
    "SELECT",
    "SET",
    "SHARE",
    "SHOW",
    "SKIP",
    "SLEEP",
    "SPACE",
    "SPACES",
    "SQL",
    "START",
    "STEP",
    "STOP",
    "SUM",
    "TABLE",
    "TABLES",
    "TEMP",
    "THEN",
    "TIME",
    "TODAY",
    "TOP",
    "TRAILER",
    "TRUE",
    "TYPE",
    "UNCONSTRAINED",
    "UNION",
    "UNIQUE",
    "UNITS",
    "UNLOAD",
    "UNLOCK",
    "UNLOAD",
    "UPDATE",
    "UPSHIFT",
    "USING",
    "VALUES",
    "WAIT",
    "WAITING",
    "WEEKDAY",
    "WHEN",
    "WHENEVER",
    "WHERE",
    "WHILE",
    "WINDOW",
    "WITH",
    "WITHOUT",
    "WORDWRAP",
    "WORK",
  ];

  //Compatibilizar com Token4glType em index.ts
  const TokenKind = {
    keyword: "keyword",
    whitespace: "whitespace",
    comment: "comment",
    identifier: "identifier",
    main: "main",
    global: "global",
    function: "function",
    command: "command",
    string: "string",
    number: "number",
    variable: "variable",
    expression: "expression",
    operator: "operator",
    builtInVar: "builtInVar",
    unknown: "unknown",
  };

  const ConstType = {
    integer: "integer",
    string: "string",
  };

  var program = { kind: "program", value: [], offset: undefined };
  var nodes = [];

  function addNode(node, subnode) {
    nodes.push(node);

    if (subnode) {
      if (node.type) {
        program.value.push(node);
      } else if (Array.isArray(node.value)) {
        program.value.push(...node.value);
      } else {
        program.value.push(node);
      }
      nodes = [];
    } 

    return node
  }

  function createNode(kind, value, info) {
    if (value) {
      const _location = location();
      const offset = {
        start: _location.start.offset,
        end: _location.end.offset,
      };
      const obj = { kind: kind, value: value, offset: offset };

      if (info) obj.info = info;

      return obj;
    }
  }

  function createNodeKeyword(value) {
    return createNode(TokenKind.keyword, value);
  }

  function createNodeId(id) {
    return createNode(TokenKind.identifier, id);
  }

  function createNodeSpace(value) {
    return createNode(TokenKind.whitespace, value);
  }

  function createNodeComment(value) {
    return createNode(TokenKind.comment, value);
  }

  function createNodeLine(line) {

    return createNode(TokenKind.line, line);
  }

  function createNodeSession(session) {

    return createNode(TokenKind.session, session);
  }







  function createNodeGlobal(value) {
    return createNode(TokenKind.global, value);
  }

  function createNodeMain(code) {
    const info = { id: "main", arguments: [], block: code };

    return createNode(TokenKind.main, info.id, info);
  }


  function createNodeVar(variable, index) {
    const info = { index: index };

    return createNode(TokenKind.variable, variable, info);
  }

  function createNodeBuiltInVar(variable) {
    return createNode(TokenKind.builtInVar, variable);
  }

  function createNodeFunction(id, _arguments, code) {
    const info = { id: id, arguments: _arguments, block: code };

    return createNode(TokenKind.function, id.value, info);
  }

  function createNodeExpression(operator, expression) {
    const info = { operator: operator, expression: expression };

    return createNode(TokenKind.expression, "", info);
  }

  function createNodeOperator(operator) {
    return createNode(TokenKind.operator, operator);
  }

  function createNodeCommand(command) {
    return createNode(TokenKind.command, command);
  }

  function createNodeNumber(dataType, value) {
    const info = { type: dataType };

    return createNode(TokenKind.number, value, info);
  }

  function createNodeString(value) {
    const info = { type: ConstType.string };

    return createNode(TokenKind.string, value, info);
  }

}

start = l:line* { return program }

line
  = SPACE? session SPACE? comment?
  / comment
  / SPACE

session
  = s:modular  { addNode(createNodeSession(s), true); }
  / s:globals  { addNode(createNodeSession(s), true); }
  / s:function { addNode(createNodeSession(s), true); }

comment
  = c:$("#" (!NL .)* NL) { return addNode(createNodeComment(c)); }
  / c:$("--" (!NL .)* NL) { return addNode(createNodeComment(c)); }
  / c:$("{" (!"}" .)* "}") { return addNode(createNodeComment(c)); }

modular = define+

globals
  = GLOBALS SPACE (define / SPACE / comment)* END SPACE GLOBALS SPACE
  / GLOBALS SPACE string_exp

function
  = MAIN SPACE blockCommand? END SPACE MAIN SPACE
  / FUNCTION
    SPACE
    ID
    parameterList
    blockCommand?
    END
    SPACE
    FUNCTION
    SPACE

blockCommand = commands+

commands
  = SPACE? command SPACE? comment? NL?
  / SPACE
  / comment

command = (define / display / call / let / prompt)

define = DEFINE SPACE ID SPACE dataType 

display = DISPLAY SPACE expressions

call
  = CALL
    SPACE
    ID
    SPACE?
    argumentList
    (SPACE RETURNING SPACE receivingVariables)?

let = LET SPACE receivingVariables SPACE? EQUAL SPACE? expressions

prompt = PROMPT SPACE string_exp SPACE FOR SPACE ID

expressions
  = l:exp_list+ e:expression { return l.concat(e); }
  / l:exp_list+ { return l; }
  / e:expression { return [e]; }

exp_list
  = SPACE? e:expression SPACE? o:OPERATOR SPACE? { return createNodeExpression(o, e); }

expression
  = string_exp
  / integer_exp
  / variable

argumentList
  = O_PARENTHESIS SPACE? C_PARENTHESIS { return []; }
  / O_PARENTHESIS a:arg_value C_PARENTHESIS { return [a]; }
  / O_PARENTHESIS a:arg_value_list+ C_PARENTHESIS { return a; }
  / O_PARENTHESIS l:arg_value_list+ a:arg_value+ C_PARENTHESIS {
      return l.concat(a);
    }

arg_value = SPACE? e:expressions SPACE? { return e; }

arg_value_list = SPACE? e:expressions SPACE? COMMA SPACE? { return e; }

parameterList
  = O_PARENTHESIS SPACE? C_PARENTHESIS { return []; }
  / O_PARENTHESIS p:param_id C_PARENTHESIS { return [p]; }
  / O_PARENTHESIS p:param_value_list+ C_PARENTHESIS { return p; }
  / O_PARENTHESIS l:param_value_list+ p:param_id+ C_PARENTHESIS {
      return l.concat(p);
    }

param_value_list = SPACE? v:ID SPACE? COMMA SPACE? { return; }

param_id = SPACE? v:ID SPACE? { return v; }

receivingVariables
  = l:var_list+ v:variable+ { return l.concat(v); }
  / l:var_list+ { return l; }
  / v:variable { return [v]; }

var_list = SPACE? v:variable SPACE? COMMA SPACE? { return; }

variable
  = v:$(ID DOT ID) { return createNodeVar(v); }
  / v:$(ID DOT ASTERISK) { return createNodeVar(v); }
  / v:ID O_BRACKET i:expressions C_BRACKET { return createNodeVar(v, i); }
  / v:ID { return createNodeVar(v); }
  / v:builtInVariables { return v; }

builtInVariables
  = v:"arg_val"i { return createNodeBuiltInVar(v); }
  / v:"arr_count"i { return createNodeBuiltInVar(v); }
  / v:"arr_curr"i { return createNodeBuiltInVar(v); }
  / v:"errorlog"i { return createNodeBuiltInVar(v); }
  / v:"fgl_keyval"i { return createNodeBuiltInVar(v); }
  / v:"fgl_lastkey"i { return createNodeBuiltInVar(v); }
  / v:"infield"i { return createNodeBuiltInVar(v); }
  / v:"int_flag"i { return createNodeBuiltInVar(v); }
  / v:"quit_flag"i { return createNodeBuiltInVar(v); }
  / v:"num_args"i { return createNodeBuiltInVar(v); }
  / v:"scr_line"i { return createNodeBuiltInVar(v); }
  / v:"set_count"i { return createNodeBuiltInVar(v); }
  / v:"showhelp"i { return createNodeBuiltInVar(v); }
  / v:"sqlca"i { return createNodeBuiltInVar(v); }
  / v:"sqlcode"i { return createNodeBuiltInVar(v); }
  / v:"sqlerrd"i { return createNodeBuiltInVar(v); }
  / v:"startlog"i { return createNodeBuiltInVar(v); }

dataType
  = r:simpleDataType     { return r; }
  / r:structuredDataType { return r; }
  / r:largeDataType      { return r; }

simpleDataType
  = r:numberType    { return r; }
  / r:timeType      { return r; }
  / r:characterType { return r; }

numberType
  = $(BIGINT / INTEGER / INT)
  / $SMALLINT
  / $((DECIMAL / DEC / NUMERIC / MONEY) (O_PARENTHESIS scale C_PARENTHESIS)?)
  / $((DOUBLE_PRECISION / FLOAT) (O_PARENTHESIS integer_exp C_PARENTHESIS)?)
  / $(REAL / SMALLFLOAT)

timeType
  = $(DATETIME SPACE datetimeQualifier)
  / $DATE
  / $INTERVAL

characterType
  = $((CHARACTER / CHAR) (O_PARENTHESIS integer_exp C_PARENTHESIS)?)
  / $(NCHAR (O_PARENTHESIS integer_exp C_PARENTHESIS)?)
  / $((VARCHAR / NVARCHAR) (O_PARENTHESIS integer_exp C_PARENTHESIS?))

largeDataType
  = $BYTE
  / $TEXT

structuredDataType
  = $(
    ARRAY SPACE?
      O_BRACKET SPACE?
      sizeArray SPACE?
      C_BRACKET SPACE
      OF SPACE
      (simpleDataType / recordDataType / largeDataType)
  )
  / $DYNAMIC_ARRAY
  / recordDataType

sizeArray = integer_exp (COMMA integer_exp)*

recordDataType
  = (RECORD SPACE LIKE tableQualifier columnQualifier)
  / RECORD member END SPACE RECORD

datetimeQualifier = datetimeQualifierWord SPACE TO SPACE datetimeQualifierWord

datetimeQualifierWord
  = YEAR
  / MONTH
  / DAY
  / HOUR
  / MINUTE
  / SECOND
  / FRACTION (O_PARENTHESIS scale C_PARENTHESIS)?

scale = integer_exp (COMMA integer_exp)?

member
  = LIKE tableQualifier columnQualifier
  / identifierList

identifierList
  = l:identifier_list+ i:identifier+ { return l.concat(i); }
  / l:identifier_list+ { return l; }
  / i:identifier { return [i]; }

identifier_list = SPACE? i:identifier SPACE? COMMA SPACE? { return i; }

identifier = SPACE? i:ID SPACE simpleDataType SPACE? { return i; }

tableQualifier
  = s:(
    (ID (AT ID)? COLON)?
      o:(ID DOT / D_QUOTE ID DOT D_QUOTE / S_QUOTE ID DOT S_QUOTE)
  )?

columnQualifier = ID DOT (ID / ASTERISK)

ID = id:$([a-zA-Z_] [a-zA-Z0-9_]*) { return createNodeId(id); }

DEFINE = k:"define"i { return createNodeKeyword(k); }

CALL = k:"call"i { return createNodeKeyword(k); }

DISPLAY = k:"display"i { return createNodeKeyword(k); }

END = k:"end"i { return createNodeKeyword(k); }

FUNCTION = k:"function"i { return createNodeKeyword(k); }

GLOBALS = k:"globals"i { return createNodeKeyword(k); }

LET = k:"let"i { return createNodeKeyword(k); }

PROMPT = k:"prompt"i { return createNodeKeyword(k); }

MAIN = k:"main"i { return createNodeKeyword(k); }

STRING = k:"string"i { return createNodeKeyword(k); }

RETURNING = k:"returning"i { return createNodeKeyword(k); }

OPERATOR = o:[~!@%^&*-+|/{}\:;<>?#_] { return createNodeOperator(o); }

EQUAL = o:"=" { return createNodeOperator(o); }

O_PARENTHESIS = o:"(" { return createNodeOperator(o); }

C_PARENTHESIS = o:")" { return createNodeOperator(o); }

O_BRACKET = o:"[" { return createNodeOperator(o); }

C_BRACKET = o:"]" { return createNodeOperator(o); }

AT = o:"@" { return createNodeOperator(o); }

DOT = o:"." { return createNodeOperator(o); }

COLON = o:":" { return createNodeOperator(o); }

COMMA = o:"," { return createNodeOperator(o); }

ASTERISK = o:"*" { return createNodeOperator(o); }

ARRAY = k:"array"i { return createNodeKeyword(k); }

BIGINT = k:"bigint"i { return createNodeKeyword(k); }

BYTE = k:"byte"i { return createNodeKeyword(k); }

CHAR = k:"CHAR"i { return createNodeKeyword(k); }

CHARACTER = k:"character"i { return createNodeKeyword(k); }

DATE = k:"date"i { return createNodeKeyword(k); }

DATETIME = k:"datetime"i { return createNodeKeyword(k); }

DEC = k:"dec"i { return createNodeKeyword(k); }

DECIMAL = k:"decimal"i { return createNodeKeyword(k); }

DOUBLE_PRECISION = k:$("double"i SPACE "precision"i) { return createNodeKeyword(k); }

DYNAMIC_ARRAY = k:$("dynamic"i SPACE "array"i) { return createNodeKeyword(k); }

FLOAT = k:"float"i { return createNodeKeyword(k); }

INT = k:"int"i { return createNodeKeyword(k); }

INTEGER = k:"integer"i { return createNodeKeyword(k); }

INTERVAL = k:"interval"i { return createNodeKeyword(k); }

LIKE = k:"like"i { return createNodeKeyword(k); }

MONEY = k:"money"i { return createNodeKeyword(k); }

NCHAR = k:"nchar"i { return createNodeKeyword(k); }

NUMERIC = k:"numeric"i { return createNodeKeyword(k); }

NVARCHAR = k:"nvarchar"i { return createNodeKeyword(k); }

OF = k:"of"i { return createNodeKeyword(k); }

FOR = k:"for"i { return createNodeKeyword(k); }

REAL = k:"real"i { return createNodeKeyword(k); }

RECORD = k:"record"i { return createNodeKeyword(k); }

SMALLFLOAT = k:"smallfloat"i { return createNodeKeyword(k); }

SMALLINT = k:"smallint"i { return createNodeKeyword(k); }

TEXT = k:"text"i { return createNodeKeyword(k); }

TO = k:"to"i { return createNodeKeyword(k); }

VARCHAR = k:"varchar"i { return createNodeKeyword(k); }

YEAR = k:"year"i { return createNodeKeyword(k); }

MONTH = k:"month"i { return createNodeKeyword(k); }

DAY = k:"day"i { return createNodeKeyword(k); }

HOUR = k:"hour"i { return createNodeKeyword(k); }

MINUTE = k:"minute"i { return createNodeKeyword(k); }

SECOND = k:"second"i { return createNodeKeyword(k); }

FRACTION = k:"fraction"i { return createNodeKeyword(k); }

// words
//   = (word (SPACE / NL))+

// word
//   = w:([a-zA-Z0-9_]+)  {
//     const word = w.join("");
//     const _type = keywordList.indexOf(word.toUpperCase()) === -1?TokenKind.word:TokenKind.keyword;

//   return createNode_type, word);
// }

integer_exp
  = t:integer_text { return createNodeNumber(ConstType.integer, parseInt(text, 10)); }

integer_text
  = "+"? d:$DIGIT+ !"."
  / "-" d:$DIGIT+ !"."

string_exp
  = s:(double_quoted_string / single_quoted_string) { return createNodeString(s); }

double_quoted_string = $(D_QUOTE double_quoted_char* D_QUOTE)

single_quoted_string = $(S_QUOTE single_quoted_char* S_QUOTE)

double_quoted_char
  = ESCAPED
  / !D_QUOTE c:. { return c; }

single_quoted_char
  = ESCAPED
  / !S_QUOTE c:. { return c; }

D_QUOTE = "\""

S_QUOTE = "'"

ESCAPED
  = "\\\"" { return '"'; }
  / "\\'" { return "'"; }
  / "\\\\" { return "\\"; }
  / "\\b" { return "\b"; }
  / "\\t" { return "\t"; }
  / "\\n" { return "\n"; }
  / "\\f" { return "\f"; }
  / "\\r" { return "\r"; }

DIGIT = [0-9]

SPACE
  = s:$[ \t\n\r]+ { return createNodeSpace(s); }
  / s:NL+

NL = s:$("\n" / "\r\n") { return createNodeSpace(s); }

NLS
  = NL
  / SPACE

EOF = !.