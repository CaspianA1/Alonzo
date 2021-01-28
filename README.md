## Alonzo

A lambda calculus REPL (named after the creator of the lambda calculus, Alonzo Church).

- Invoke `run.sh` to enter the REPL.

### Top level features:
- Type `:q` to quit and `:d` to enter the debugger.
- Type any valid lambda calculus expression or free binding to evaluate it.
- When attempting to reassign a binding, the interpreter throws a warning.
  
### Builtin functions:
```
true = \x. \y. x

false = \x. \y. y

if = \state. \t. \f. (state t) f

and = \a. \b. ((if a) b) false

or = \a. \b. ((if a) true) b

not = \a. ((if a) false) true

id = \a. a
```
- `Alonzo` is lexically scoped and supports closures.
- The Prolog version used in development is [GNU Prolog](http://www.gprolog.org/manual/gprolog.html).
