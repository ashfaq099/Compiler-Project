
# **Custom Compiler  using Flex & Bison**

This project implements a fully-functional compiler front-end for a custom high-level language.  
It includes:  

✔ A lexer built with **Flex**  
✔ A parser + semantic engine built with **Bison**  
✔ A lightweight runtime that executes the parsed program  
✔ Support for variables, types, expressions, loops, conditionals, functions, I/O, and math operations  

The language resembles a compact educational DSL designed to demonstrate core compiler concepts: tokenization, grammar design, symbol-table handling, semantic checking, and basic interpretation.


---

## **🚀 Features at a Glance**

### ✓ **Full Lexer (Flex)**

Handles:

* Keywords (`if`, `Otherwise`, `Repeat`, `As long as`, `def`, `call`, etc.)
* Numeric literals (int, decimal)
* Strings with escape handling
* Operators:
  `++`, `--`, `===`, `!!!`, `<`, `>`, `<=`, `>=`, `&&`, `||`, `^^`, `~~`, `**`
* Comments:
  `/>`   → single-line
  `/* ... */` → multi-line
* Token validation and unknown-character reporting

---

### ✓ **Full Parser + Semantic Engine (Bison)**

Supports:

#### **Data Types**

* `number`
* `decimal`
* `string`

#### **Variable Operations**

* Declarations (multiple per line)
* Assignments
* Type checking
* Duplicate-name detection
* Symbol table with dynamic memory allocation

#### **Expressions**

* Arithmetic: `+ - * / %`
* Comparison: `< > <= >= === !!!`
* Boolean: `&& || ^^ ~~`
* Pre/post increment/decrement
* Mathematical functions:
  `sin`, `cos`, `tan`, `sqrt`, `log10`, `log2`, `ln`
* Power operator: `**`

#### **Control Flow**

* `if (...) {}`

* `Otherwise if (...) {}`

* `Otherwise {}`
  → supports multi-branch matching with internal state tracking

* `Repeat(i in [from, to, by])`
  → custom for-loop simulation with iteration logging

* `As long as (condition)`
  → custom while-loop with semantics for incremental or decremental bounds

#### **Functions**

* `def name(args) -> returnType { ... }`
* Argument type checking
* Duplicate function detection
* Function call validation

#### **I/O**

* `input(x, y)`
* `Output(a, b, s)`

---

## **📁 Project Structure**

```
├── bison.y      # Bison grammar + semantic logic
├── flex.l       # Flex scanner rules
├── input.txt    # Sample program input
├── output.txt   # Execution output
└── Makefile     # Build automation (if you create one)
```

---

## **🧠 Architecture Overview**

### **1. Symbol Table**

Implemented manually using arrays of `info` structs:

```
typedef struct {
    char *name;
    int type;          // NUMBER | DECIMAL | STRING
    int length;
    int is_array;
    int *ival;
    double *dval;
    char **sval;
} info;
```

Handles:

* dynamic string copying
* array/non-array allocation
* runtime updates during `input`, assignments, and increments

---

### **2. Function Table**

Each function stores:

```
typedef struct {
    char *fname;
    info *fptr;       // its parameters
    int var_cnt;
} stack;
```

Matching includes:

* existence check
* number of arguments
* type validation
* rejection signalling (`function_rejected`)

---

### **3. Runtime Model**

The program is parsed and executed immediately (simple interpreter model).
All print, math, and loop operations run during parsing via semantic actions — no intermediate IR.

---

## **▶️ How to Build & Run**

### **1. Generate scanner & parser**

```bash
bison -d bison.y
flex flex.l
gcc lex.yy.c bison.tab.c -lm -o compiler
```

### **2. Run**

```bash
./compiler
```

It reads from **input.txt** and writes to **output.txt** automatically inside `main()`.



# ✅ **Example Input Program**

```
import file.h
Main:

/> single line comment

/* multi
line
comment
*/

decimal varriable1 = sin(90);
decimal p = 2 ** 3;

number x = 1, y = 0;
number z = x ^^ y;

number a = 11, b = 20, c = 2;
Output(a, b, c);

decimal d = 1.10, e = d;
string s = "text";
Output(s);

/> input(a, b);
/> input(d);

if(a > b) {
    number es = 10;
}
Otherwise if(a < b) {
    number eq = 69;
}
Otherwise {
    number ef = 20;
}

number aa = b % 3;
Output(aa);

number bb = a <= b;
Output(bb);

Repeat(i in [1, 10, 2]) {
    Output(a);
}

As long as(a++ <= b) {
    Output(a);
}

As long as(b-- > 15) {
    Output(a);
}

As long as(a++ !!! 15) {
    Output(a);
}

def func(number arg) -> number {
    ;
}

call func(a);
```

---

# ✅ **Output (output.txt)**



```
SINGLELINE COMMENT DETECTED!
The Comment is: single line comment

MULTILINE COMMENT DETECTED!
The Comment is: multi line comment

Variable name is: varriable1
Variable value is: 0.893997

Variable name is: p
Variable value is: 8.000000

Variable name is: x
Variable value is: 1

Variable name is: y
Variable value is: 0

Variable name is: z
Variable value is: 1

Variable name is: a
Variable value is: 11

Variable name is: b
Variable value is: 20

Variable name is: c
Variable value is: 2

Value of a is: 11
Value of b is: 20
Value of c is: 2

Variable name is: d
Variable value is: 1.100000

Variable name is: e
Variable value is: 1.100000

Variable name is: s
Variable value is: text
Value of s is: text

SINGLELINE COMMENT DETECTED!
The Comment is: input(a, b);

SINGLELINE COMMENT DETECTED!
The Comment is: input(d);

Variable name is: es
Variable value is: 10
IF BLOCK Condition Didn't match in IF Block.

Variable name is: eq
Variable value is: 69
Condition Matched in Otherwise if Block.

Variable name is: ef
Variable value is: 20
Condition Already Matched.

Variable name is: aa
Variable value is: 2
Value of aa is: 2

Variable name is: bb
Variable value is: 1
Value of bb is: 1

Value of a is: 11
Repeat Loop Block
Repeat Loop Iteration: 1
Repeat Loop Iteration: 2
Repeat Loop Iteration: 3
Repeat Loop Iteration: 4
Repeat Loop Iteration: 5

Value of a is: 11
As long as BLOCK
As Long As Loop Iteration: 1
As Long As Loop Iteration: 2
As Long As Loop Iteration: 3
As Long As Loop Iteration: 4
As Long As Loop Iteration: 5
As Long As Loop Iteration: 6
As Long As Loop Iteration: 7
As Long As Loop Iteration: 8
As Long As Loop Iteration: 9
As Long As Loop Iteration: 10

Value of a is: 11
As long as BLOCK
As Long As Loop Iteration: 1
As Long As Loop Iteration: 2
As Long As Loop Iteration: 3
As Long As Loop Iteration: 4
As Long As Loop Iteration: 5

Value of a is: 11
As long as BLOCK
As Long As Loop Iteration: 1
As Long As Loop Iteration: 2
As Long As Loop Iteration: 3
As Long As Loop Iteration: 4

Declaring Function
Variable name is: arg
Variable value is: 0
Function Successfully Called.

COMPILATION SUCCESSFUL!
```

---


