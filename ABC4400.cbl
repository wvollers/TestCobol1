       IDENTIFICATION DIVISION.
       environment division.
       special-names.
         crt status is key-status.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "common_ws.cpy".
      $if use-sql defined
       EXEC SQL INCLUDE SQLCA END-EXEC.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC
           01 welcome-message   pic x(50).
       EXEC SQL END DECLARE SECTION END-EXEC
      $end

       linkage section.
       copy "common_lnk.cpy".
      
       SCREEN SECTION.
      $if use-sql defined
       COPY "setupwelcomemsg.ss".
      $end

       copy "common_ss.cpy".
       PROCEDURE DIVISION.
           move "Setup Welcome Message" to Menu-Name
           move "WM_M01" to Menu-Id
      $if use-sql defined
           perform clr-screen
             display g-constmenu
             display g-menuheader
             accept g-constmenu
             perform f1-or-quit
      
             EXEC SQL
               insert into SystemMessages
               (Message) values (:welcome-message)
             END-EXEC
             EXEC SQL commit END-EXEC
           if sqlcode not = 0
                display "Error: cannot connect "
                display sqlcode
                display sqlerrmc
                goback
           end-if
      $end
           goback.

       copy "common.cpy".