--
--   CIS*3190 Assignment #4
--
--      Name: e Calculator
--      Author: Jacob Wadsworth
--      Date of Last Revision: April 8, 2022
--      Summary: This program calculates e to n given decimal places
--

with Ada.Text_IO; use Ada.Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure calce is

    type numArray is array(integer range 0..10000) of integer;

    --checks if the file exists
    function Does_File_Exist(Name : String) return Boolean is
        The_File : Ada.Text_IO.File_Type;
    begin
        Open (The_File, In_File, Name);
        Close (The_File);
        return true;
    exception
        when Name_Error =>
            return false;
    end Does_File_Exist;

    --gets the filename for input or output
    function getFilename(rw : character) return unbounded_string is
        filename : unbounded_string;
        yn : character;
    begin
        if rw = 'r' then

            --loops asking for filename until file is found
            loop
                put_line("Please input filename to be read:");
                get_line(filename);

                exit when Does_File_Exist(to_string(filename));

                put_line("Error: file not found");
            end loop;

        elsif rw = 'w' then

            --loops asking for filename until valid filename is found
            loop
                put_line("Please input filename to be writen:");
                get_line(filename);

                if Does_File_Exist(to_string(filename)) then
                    put_line("The file " & filename & " already exists");
                    put_line("Would you like to overwrite this file? (y/n)");

                    get(yn);
                    skip_line;

                    if yn = 'y' then
                        exit;
                    end if;

                else

                    exit;

                end if;

            end loop;

        else
            put_line("Error: rw");
        end if;

        return filename;

    end getFilename;

    --check if a string is a number
    function is_numeric (Item : in unbounded_string) return Boolean is
        Dummy : Float;
    begin
        Dummy := Float'Value (To_String(Item));
        return True;
    exception
        when others =>
            return False;
    end is_numeric;

    --Calculate the Value of e to n digits and return it in a int array
    function calculate_e (n : in integer) return numArray is
        eList : numArray;
        m : integer;
        test : float;
        carry : integer;
        temp : integer;
        coef : numArray;
    begin
        m := 4;
        test := float(n+1) * 2.30258509;

        --calculate value of m
        while float(m) * (log(float(m)) - 1.0) + 0.5 * log(6.2831852 * float(m)) < test loop
            m := m + 1;
        end loop;

        --set coef values to 1
        for j in 2..m loop
            coef(j) := 1;
        end loop;

        --set first value to 2
        eList(0) := 2;

        --calculate values and store them in eList
        for i in 1..n loop
            carry := 0;

            for j in reverse 2..m loop
                temp := coef(j) * 10 + carry;
                carry := temp / j;
                coef(j) := temp - carry * j;
            end loop;
            eList(i) := carry;
        end loop;

        return eList;
    end calculate_e;

    --write the value of e to a file
    procedure keepe(eList : numArray; filename : unbounded_string; n : integer) is
        outfp : file_type;
    begin

        --create file
        create(outfp, out_file, to_string(filename));

        --set write to file
        set_output(outfp);

        --print out e into file
        put(integer'image(eList(0)));
        put(".");
        for i in 1..(n-1) loop
            put(trim(integer'image(eList(i)), Ada.Strings.Left));
        end loop;

        --reset output
        set_output(standard_output);

        --close file
        if is_open(outfp) then
            close(outfp);
        end if;

    end keepe;

    n : integer;
    input : unbounded_string;
    filename : unbounded_string;
    eEst : numArray;

begin

    --get input until input is an int
    loop
        put_line("How many digits would you like to calculate?");
        input := get_line;

        if is_numeric(input) = True and Integer'Value(To_String(input)) >= 0 then
            n := Integer'Value(To_String(input));
            exit;
        end if;

    end loop;

    --get filename
    filename := getFilename('w');

    --calculate e
    eEst := calculate_e (n);

    --save e to file
    keepe(eEst, filename, n);

end calce;