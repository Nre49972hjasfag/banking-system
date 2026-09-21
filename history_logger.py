from datetime import datetime
import mysql.connector

def log_transaction(cursor, acc_num, amount, t_type, recv_acc=None, chq_num=None):
    """Inserts a new transaction record into the database."""
    log_query = """
        INSERT INTO transaction_history (amount, type, date, time, account_num, recv_acc_num, cheque_num) 
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    current_date = datetime.now().strftime('%Y-%m-%d')
    current_time = datetime.now().strftime('%H:%M:%S')
    
    cursor.execute(log_query, (amount, t_type, current_date, current_time, acc_num, recv_acc, chq_num))

def show_transaction_history(cursor, acc_num):
    """Fetches and beautifully displays all transaction records for an account."""
    print("\n----- TRANSACTION HISTORY -----")
    query = """
        SELECT type, amount, date, time, recv_acc_num, cheque_num 
        FROM transaction_history 
        WHERE account_num = %s
        ORDER BY serial_no DESC
    """
    cursor.execute(query, (acc_num,))
    rows = cursor.fetchall()
    
    if not rows:
        print("No transactions found.")
        return

    for i, row in enumerate(rows, start=1):
        t_type, t_amt, t_date, t_time, r_acc, chq_num = row
        t_type_cap = t_type.capitalize()
        
        if t_type == 'transfer':
            print(f"{i}. {t_date} {t_time} - {t_type_cap} of {t_amt} to Acc #{r_acc}")
        elif t_type == 'deposit' and chq_num:
            print(f"{i}. {t_date} {t_time} - {t_type_cap} of {t_amt} via Cheque #{chq_num}")
        else:
            print(f"{i}. {t_date} {t_time} - {t_type_cap} of {t_amt}")
