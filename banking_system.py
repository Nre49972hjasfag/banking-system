import sys

#------------------------ # PYTHON BANKING SYSTEM #------------------------ 
name = input("Enter your name: ")

# PIN CREATION
while True:
    pin = input("Set a 4-digit PIN: ")
    if pin.isdigit() and len(pin) == 4:
        break
    else:
        print("Invalid PIN. PIN must be exactly 4 digits. \n")

# LOGIN SYSTEM
attempts = 3
authenticated = False

while attempts > 0:
    entered_pin = input("Enter PIN to login: ")
    if entered_pin == pin:
        print("\nLogin Successful!")
        authenticated = True
        break
    else:
        attempts -= 1
        if attempts > 0:
            print(f"Incorrect PIN! You have {attempts} attempts left.\n")

if not authenticated:
    print("Too many incorrect attempts. Access locked.")
    sys.exit()

# ACCOUNT DATA
balance = 0
history = []

# MAIN MENU
while True:
    print("\n" + "=" * 50)
    print("             PYTHON BANKING SYSTEM")
    print("=" * 50)
    print("1. Deposit")
    print("2. Withdraw")
    print("3. Show Balance")
    print("4. Transaction History")
    print("5. Transfer Money")
    print("6. Exit")
    
    choice = input("Choose an option: ")
    
    # DEPOSIT
    if choice == "1":
        amount = input("Enter amount to deposit: ")
        if amount.isdigit():
            amount = int(amount)
            if amount > 0:
                balance += amount
                history.append(f"Deposited {amount}")
                print(f"{amount} deposited successfully!")
                print(f"New Balance: {balance}")
            else:
                print("Amount must be greater than zero.")
        else:
            print("Invalid amount!")
            
    # WITHDRAW
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
                history.append(f"Withdrew {amount}")
                print(f"{amount} withdrawal successful!")
                print(f"New Balance: {balance}")
        else:
            print("Invalid amount!")
            
    # SHOW BALANCE
    elif choice == "3":
        print("\n----- ACCOUNT DETAILS -----")
        print("Account Holder:", name)
        print("Balance       :", balance)
        
    # TRANSACTION HISTORY
    elif choice == "4":
        print("\n----- TRANSACTION HISTORY -----")
        if len(history) == 0:
            print("No transactions found.")
        else:
            for i, transaction in enumerate(history, start=1):
                print(f"{i}. {transaction}")
                
    # TRANSFER
    elif choice == "5":
        recipient = input("Enter recipient's name: ").strip()
        if not recipient:
            print("Recipient name cannot be empty.")
        else:
            amount = input(f"Enter amount to transfer to {recipient}: ")
            if amount.isdigit():
                amount = int(amount)
                if amount <= 0:
                    print("Amount must be greater than zero.")
                elif amount > balance:
                    print("Insufficient Balance for this transfer!")
                else:
                    balance -= amount
                    history.append(f"Transferred {amount} to {recipient}")
                    print(f"Successfully transferred {amount} to {recipient}!")
                    print(f"New Balance: {balance}")
            else:
                print("Invalid amount!")

    # EXIT
    elif choice == "6":
        print("\nThank You For Banking With Us!")
        print("Have a Great Day!")
        break
        
    # INVALID CHOICE
    else:
        print("Invalid choice! Please select a valid option.")
