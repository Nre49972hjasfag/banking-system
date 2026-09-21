import sys
import mysql.connector
# Import the decoupled transaction history module
import history_logger 

# -------------------------------------------------------------
# DATABASE CONNECTION SETUP
# -------------------------------------------------------------
try:
    db = mysql.connector.connect(
        host="localhost",
        user="root",               # Change to your MySQL user
        password="your_password",  # Change to your MySQL password
        database="bank_schema"
    )
    cursor = db.cursor()
except mysql.connector.Error as err:
    print(f"Database Connection Error: {err}")
    sys.exit()

# -------------------------------------------------------------
# DYNAMIC LOGIN SYSTEM
# -------------------------------------------------------------
print("=" * 50)
print("          WELCOME TO PYTHON BANKING SYSTEM")
print("=" * 50)

attempts = 3
authenticated = False
account_data = None

while attempts > 0:
    username = input("Enter Username: ").strip()
    entered_pin = input("Enter 4-digit Card PIN: ").strip()

    query = """
        SELECT c.f_name, c.l_name, ba.acc_num, ba.balance
        FROM login_account la
        JOIN bank_account ba ON la.login_id = ba.login_id
        JOIN client c ON ba.client_id = c.client_id
        JOIN card cd ON ba.card_num = cd.card_num
        WHERE la.username = %s AND cd.Pin_code = %s AND ba.status = 1
    """
    cursor.execute(query, (username, entered_pin))
    account_data = cursor.fetchone()

    if account_data:
        name = f"{account_data[0]} {account_data[1]}"
        acc_num = account_data[2]
        balance = account_data[3]
        print(f"\nLogin Successful! Welcome back, {name}.")
        print(f"Linked Account Number: {acc_num}")
        authenticated = True
        break
    else:
        attempts -= 1
        if attempts > 0:
            print(f"Invalid credentials or inactive card! {attempts} attempts left.\n")

if not authenticated:
    print("Too many incorrect attempts. Access locked.")
    cursor.close()
    db.close()
    sys.exit()

# -------------------------------------------------------------
# MAIN APPLICATION MENU
# -------------------------------------------------------------
while True:
    print("\n" + "=" * 50)
    print(f"             BANKING MENU (Acc: {acc_num})")
    print("=" * 50)
    print("1. Deposit")
    print("2. Withdraw")
    print("3. Show Balance")
    print("4. Transaction History")
    print("5. Transfer Money")
    print("6. Exit")
    
    choice = input("Choose an option: ")
    
    # 1. DEPOSIT
    if choice == "1":
        amount = input("Enter amount to deposit: ")
        if amount.isdigit():
            amount = int(amount)
            if amount > 0:
                balance += amount
                cursor.execute("UPDATE bank_account SET balance = %s WHERE acc_num = %s", (balance, acc_num))
                
                # Using the imported history module
                history_logger.log_transaction(cursor, acc_num, amount, 'deposit')
                
                db.commit()
                print(f"\n{amount} deposited successfully!")
                print(f"New Balance: {balance}")
            else:
                print("Amount must be greater than zero.")
        else:
            print("Invalid amount!")
            
    # 2. WITHDRAW
    elif choice == "2":
        amount = input("Enter amount to withdraw: ")
        if amount.isdigit():
            amount = int(amount)
            if amount <= 0:
                print("Amount must be greater than zero.")
            elif amount > balance:
                print("Insufficient Balance!")
            else:
                balance -= amount
                cursor.execute("UPDATE bank_account SET balance = %s WHERE acc_num = %s", (balance, acc_num))
                
                # Using the imported history module
                history_logger.log_transaction(cursor, acc_num, amount, 'withdraw')
                
                db.commit()
                print(f"\n{amount} withdrawal successful!")
                print(f"New Balance: {balance}")
        else:
            print("Invalid amount!")
            
    # 3. SHOW BALANCE
    elif choice == "3":
        cursor.execute("SELECT balance FROM bank_account WHERE acc_num = %s", (acc_num,))
        balance = cursor.fetchone()[0]
        
        print("\n----- ACCOUNT DETAILS -----")
        print("Account Holder:", name)
        print("Account Number:", acc_num)
        print("Balance       :", balance)
        
    # 4. TRANSACTION HISTORY
    elif choice == "4":
        # Using the imported history module to print history
        history_logger.show_transaction_history(cursor, acc_num)
                
    # 5. TRANSFER
    elif choice == "5":
        target_acc = input("Enter recipient's Account Number: ").strip()
        if not target_acc.isdigit():
            print("Invalid account number format.")
        else:
            target_acc = int(target_acc)
            if target_acc == acc_num:
                print("You cannot transfer money to your own account.")
                continue
                
            cursor.execute("SELECT balance FROM bank_account WHERE acc_num = %s AND status = 1", (target_acc,))
            recipient_data = cursor.fetchone()
            
            if not recipient_data:
                print("Recipient account number not found or inactive.")
            else:
                amount = input(f"Enter amount to transfer to Account #{target_acc}: ")
                if amount.isdigit():
                    amount = int(amount)
                    if amount <= 0:
                        print("Amount must be greater than zero.")
                    elif amount > balance:
                        print("Insufficient Balance for this transfer!")
                    else:
                        recipient_balance = recipient_data[0]
                        
                        balance -= amount
                        recipient_balance += amount
                        
                        cursor.execute("UPDATE bank_account SET balance = %s WHERE acc_num = %s", (balance, acc_num))
                        cursor.execute("UPDATE bank_account SET balance = %s WHERE acc_num = %s", (recipient_balance, target_acc))
                        
                        # Using the imported history module to log the bank transfer
                        history_logger.log_transaction(cursor, acc_num, amount, 'transfer', recv_acc=target_acc)
                        
                        db.commit()
                        print(f"\nSuccessfully transferred {amount} to Account #{target_acc}!")
                        print(f"New Balance: {balance}")
                else:
                    print("Invalid amount!")

    # 6. EXIT
    elif choice == "6":
        print("\nThank You For Banking With Us!")
        print("Have a Great Day!")
        break
        
    else:
        print("Invalid choice! Please select a valid option.")

cursor.close()
db.close()
