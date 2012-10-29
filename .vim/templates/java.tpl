//
// DESCRIPTION
//
//     TODO This is a java example that runs a command in a Bash shell.
//     Remember, Java requires that the class name be the same as the filename.
//
// LICENSE
// 
//     This license is OSI and FSF approved as GPL-compatible.
//     This license identical to the ISC License and is registered with and
//     approved by the Open Source Initiative. For more information vist:
//         http://opensource.org/licenses/isc-license.txt
// 
//     TODO: Copyright (c) 4-digit year, Company or Person's Name
// 
//     Permission to use, copy, modify, and/or distribute this software for any
//     purpose with or without fee is hereby granted, provided that the above
//     copyright notice and this permission notice appear in all copies.
// 
//     THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//     WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//     MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//     ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//     WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//     ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//     OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
// 

import java.io.*;
import java.util.*;

public class TODO_shell
{

    /** This tests the runBashShellCommand method.
     *  The following are some examples of how it works:
     *
     *      $ java shell echo Hello
     *      0
     *      Hello
     *     
     *      $ java shell "echo Hello; exit 1"
     *      1
     *      Hello
     *
     */

    public static void main(String args[])
        throws IOException, java.lang.InterruptedException

    {
        // TODO This is an example java application.
        System.out.println (runBashShellCommand (args));
        System.exit (0);
    }

    /** This runs a command in a Bash shell and returns the output.
     *
     * For example, the following should print "hello":
     *
     *      String [] args = {"foo=hello", ";", "echo", "$foo"};
     *      System.out.println (runBashShellCommand (args));
     *
     * You may combine commands and arguments into a single string.
     * This is equivalent to the previous example:
     *
     *      String [] args = {"foo=hello ; echo $foo"};
     *      System.out.println (runBashShellCommand (args));
     *
     * This method will CLOSE the stdin of the subprocess so that it cannot
     * read from this filedescriptor. For example, the following should be
     * safe; Bash will simply set 'foo' to an empty string instead of blocking
     * on the 'read' call.
     *
     *      String [] args = {"read", "foo", ";", "echo", "$foo"};
     *      System.out.println (runBashShellCommand (args));
     *
     * Comments: This method is probably overkill.
     *
     * @author Noah Spurrier
     * @param args The first element should be the command to be run.
     *               Additional elements should be arguments.
     * @return the output of the command as a String. The first line of the
     *          string will be the exit code from the command that was run.
     * @throws IOException if there was a problem with the subshell.
     * @throws InterruptedException if the subshell was killed.
     */

    public static String runBashShellCommand (String args[])
        throws IOException, java.lang.InterruptedException

    {
        java.util.List<String>
            command_and_args = new java.util.ArrayList<String> ();
        command_and_args.add ("/bin/bash");
        command_and_args.add ("-c");
        StringBuffer cmd_string = new StringBuffer ();
        for (String arg : args) { cmd_string.append (arg).append (' '); }
        command_and_args.add (cmd_string.toString().trim());

        // Start Bash and script.
        ProcessBuilder pb = new ProcessBuilder (command_and_args);
        pb.redirectErrorStream (true);
        Process process = pb.start ();

        //////////////////////////////////////////////////////////////////////
        // WARNING: There is a race condition here. We want the subprocess to
        // have its stdin cutoff BEFORE it actually tries to read from stdin.
        // This is mainly to be proper; not to prevent any sort of dead-lock.
        // There is no danger that this will block us since the subprocess runs
        // asynchronously. This shouldn't be a big deal, but it should be
        // tested to be sure. -- Noah
        process.getOutputStream().close();

        // Get output from the command.
        BufferedReader br = new BufferedReader (new
            InputStreamReader (process.getInputStream()));
        StringBuffer out = new StringBuffer ();
        String line = null;
        while ((line = br.readLine ()) != null)
        {
            out.append (line).append ('\n');
        }
        // Wait for process to finish.
        int exit_code = process.waitFor();
        out.insert (0, String.valueOf(exit_code) + "\n");
        return out.toString();
    }
}

// vim:set sr et ts=4 sw=4 ft=java: // See Vim, :help 'modeline'
