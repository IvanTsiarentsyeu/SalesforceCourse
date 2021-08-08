1) Create apex class that can be lunched from Process Builder (for Account).
2) Apex class should make next logic: When new Account is created, create new Task object with Subject “Negotiations with {Account.Name}”, link created Account with this Task.
3) If Account is updated and Account has more than 3 Tasks => assign all Tasks to one User (random active User)  
4) Collect all code in remote git repository for review
