import glob
import os
import sys 
from time import sleep 


# mailbox object
class MailBox:
    """Mailbox information"""
    def __init__(self,name, path, color):
        self.name = name
        self.path = path
        self.color = color 
    def newMail(self):
        p = os.path.expanduser(self.path) + '/new/*'
        num = len(glob.glob(p))
        return num


# list of mailboxes
mail_boxes = []
mail_boxes.append(MailBox('gmail', '~/.mail/gmail/INBOX', '#00FF00'))
mail_boxes.append(MailBox('tut', '~/.mail/tut/INBOX', '#FF0000'))
mail_boxes.append(MailBox('ME', '~/.mail/mikrosoft/INBOX', '#FF0000'))
mail_boxes.append(MailBox('facebook', '~/.mail/gmail/Facebook', '#0000FF'))
mail_boxes.append(MailBox('huutonet', '~/.mail/gmail/Huutonet', '#FFFF00'))
mail_boxes.append(MailBox('mikrosoft', '~/.mail/gmail/Mikrosoft', '#000099'))
mail_boxes.append(MailBox('physics', '~/.mail/tut/Physics', '#FFFF00'))
mail_boxes.append(MailBox('batch', '~/.mail/tut/batch', '#FFFF00'))
mail_boxes.append(MailBox('batch', '~/.mail/mikrosoft/batch', '#FFFF00'))
mail_boxes.append(MailBox('hiukkanen', '~/.mail/tut/Hiukkanen', '#FF00FF'))
mail_boxes.append(MailBox('hiukkanen', '~/.mail/gmail/Hiukkanen', '#FF00FF'))
mail_boxes.append(MailBox('vandaalit', '~/.mail/vandaalit/INBOX', '#999999'))
mail_boxes.append(MailBox('GMX', '~/.mail/gmx/INBOX/', '#FF00FF'))


# print line function
def printLine(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()


# main function
def main(mail_boxes):
    printLine('{"version":1}')
    printLine('[')
    printLine('[]')

    while True:
        message = checkMail(mail_boxes)
        printLine(message)
        sleep(30)


# mail check function
def checkMail(mail_boxes):

    # row start
    row = ',['
    nonemptyboxes = 0

    # loop through all mailboxes
    for box in mail_boxes:

        if box.newMail() > 0:
            # format message
            newrow = '{"color":"' + box.color + '","full_text":"' + box.name + ' ' + str(box.newMail()) + '"}'

            # append to row
            if nonemptyboxes > 0:
                row = row + ',' + newrow
            else:
                row = row + newrow

            # count boxes which have new mail
            nonemptyboxes = nonemptyboxes + 1

    row = row + ']'

    if nonemptyboxes == 0:
        row = ',[{"full_text":"no new mail"}]'

    return row


main(mail_boxes)
