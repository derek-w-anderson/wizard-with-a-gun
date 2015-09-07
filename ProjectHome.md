## Credits ##

  * Derek Anderson (Programming)
  * Benjamin Ellis (Art & Music)
  * Robert Holiday (Enemy Design)

## Screenshots ##

<img src='http://i.imgur.com/SxTed.png' />

<img src='http://i.imgur.com/SDYOk.png' />

## Setup ##
  1. Download TortoiseSVN and install it.
  1. Create an empty folder for the project somewhere on your computer.
  1. Right-click the folder and choose _SVN Checkout_.
  1. Under URL of respository, type _https://wizardwithagun.googlecode.com/svn/trunk/_ and click OK.
  1. When it prompts you for a username and password, enter your Google username and the password generated at the top of Profile > Settings (in the upper right-hand corner of this page, assuming you're logged in).
## Every-Day Usage ##
  1. Right-click the project folder and choose _SVN Update_ to get the latest copy of the project.
  1. Make some changes to the project (add/fix some code, modify the .fla, whatever) and save.
  1. Make sure everything still works! **Never commit code that breaks things!**
  1. Right-click the project folder and choose _SVN Update_ to merge any changes that someone else may have made since you last updated.
  1. Right-click the project folder again and choose _SVN Commit_.
  1. Type a short message that summarizes the changes you made, make sure the files you added/removed/changed are checked and click OK.

## Coding Guidelines ##

  * Always use **tabs**, not spaces when coding. It's the default in Flash and it will keep our code looking the same for everyone.
  * Use whitespace sparingly - only put one blank line between functions, if/else/for blocks, and pieces of code that are conceptually distinct.
  * For packages, classes and functions, put curly braces on their own lines. For loops and conditional statements (if/else), put the first brace on the same line as the condition. Example:

```
package
{
    import flash.display.*;

    public class Math
    {
        public function addNumbersUnder10(x:int, y:int): int
        {
            if (x < 10 && y < 10) {
                return x + y;
            } else {
                return -1;
            }
        }
    }
}
```