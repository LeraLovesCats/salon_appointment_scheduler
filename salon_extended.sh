  #!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\nSalon Of Your Dreams\n"

MAIN_MENU() {
  if [[ $1 ]]
  then echo -e "\n$1"
  fi

echo -e "\nWelcome to Salon Of Your Dreams, how can I help you??"
echo -e "\n1. Schedule an appointment\n2. Reschedule an appointment\n3. Cancel an appointement\n4. Exit"
read MAIN_MENU_SELECTION

case $MAIN_MENU_SELECTION in
1) SCHEDULE_APPOINTMENT ;;
2) RESCHEDULE_APPOINTMENT ;;
3) CANCEL_APPOINTMENT ;;
4) EXIT ;;
*) MAIN_MENU "Please enter a valid option." ;;
esac
}

 SCHEDULE_APPOINTMENT(){

    if [[ $1 ]]
  then echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
   
   echo -e "\nWhat service would you like?\n"
   echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME 
     do
     echo "$SERVICE_ID) $SERVICE_NAME"
     done

   read SERVICE_ID_SELECTED

   if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
   then 
   SCHEDULE_APPOINTMENT "That is not a valid input."
   elif [[ $SERVICE_ID_SELECTED > 5 || $SERVICE_ID_SELECTED == 0 ]]
   then
   SCHEDULE_APPOINTMENT "That is not a valid number."
   else
   echo -e "\nWhat's your phone number?"
   read CUSTOMER_PHONE

   CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

     if [[ -z $CUSTOMER_NAME ]]
     then
     echo -e "\nWhat's your name?"
     read CUSTOMER_NAME
     INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
     fi
   
   echo -e "\nWhat time would you like to schedule?"
   read SERVICE_TIME

   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    
   APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
   
   SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

   SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ |/"/')
   SERVICE_TIME_FORMATTED=$(echo $SERVICE_TIME | sed 's/ |/"/')
   CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/ |/"/')
   

   MAIN_MENU "I have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME_FORMATTED, $CUSTOMER_NAME_FORMATTED."
   fi  
 }

 RESCHEDULE_APPOINTMENT(){

  if [[ $1 ]]
  then echo -e "\n$1"
  fi
   
   SERVICES=$($PSQL "SELECT service_id, name FROM services")

   echo -e "\nWhat service were you scheduled for?\n"
   echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME 
     do
     echo "$SERVICE_ID) $SERVICE_NAME"
     done

   read SERVICE_ID_SELECTED
   
   if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
   then 
   RESCHEDULE_APPOINTMENT "That is not a valid input."
   elif [[ $SERVICE_ID_SELECTED > 5 || $SERVICE_ID_SELECTED == 0 ]]
   then
   RESCHEDULE_APPOINTMENT "That is not a valid number."
   else
   echo -e "\nWhat's your phone number?"
   read CUSTOMER_PHONE

   echo -e "\nWhat time would you like to reschedule?"
   read SERVICE_TIME

   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

   RESCHEDULE_APPOINTMENT_RESULT=$($PSQL "UPDATE appointments SET time='$SERVICE_TIME' WHERE customer_id=$CUSTOMER_ID")

   MAIN_MENU "Your appointment has been successfully rescheduled."
   fi
 }

 CANCEL_APPOINTMENT(){
  
    if [[ $1 ]]
    then echo -e "\n$1"
    fi
    
   SERVICES=$($PSQL "SELECT service_id, name FROM services")

   echo -e "\nWhat service were you scheduled for?\n"
   echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME 
     do
     echo "$SERVICE_ID) $SERVICE_NAME"
     done

   read SERVICE_ID_SELECTED
   
   if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
   then 
   CANCEL_APPOINTMENT "That is not a valid input."
   elif [[ $SERVICE_ID_SELECTED > 5 || $SERVICE_ID_SELECTED == 0 ]]
   then
   CANCEL_APPOINTMENT "That is not a valid number."
   else
   echo -e "\nWhat's your phone number?"
   read CUSTOMER_PHONE

   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

   CANCEL_APPOINTMENT_RESULT=$($PSQL "DELETE FROM appointments WHERE customer_id=$CUSTOMER_ID AND service_id= $SERVICE_ID_SELECTED")

   MAIN_MENU "Your appointment has been successfully canceled."
   fi
 }

 EXIT(){
 echo -e "\nThank you for stopping in."

 }

MAIN_MENU
