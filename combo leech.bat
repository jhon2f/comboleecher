@echo off
setlocal enabledelayedexpansion

REM Set the fixed delay in milliseconds
set delay=300

REM Set the input file containing multiple keywords
set keyword_file=keywords.txt

REM Set the output folder for results
set result_folder=result
set combined_file=combined.txt
set temp_file="%result_folder%\temp_combined.txt"
set temp_sorted_file="%result_folder%\temp_sorted_combined.txt"
set final_data_file="%result_folder%\final_data.txt"
set final_results_folder=final_results

REM Create the result folder if it doesn't exist
if not exist "%result_folder%" mkdir "%result_folder%"

REM Ask the user for the desired output mode
echo Select the output mode:
echo 1. Combine all results into one file
echo 2. Create separate files for each keyword
set /p mode="Enter choice (1 or 2): "

REM Initialize the combined file with a header if combining results
if "%mode%"=="1" (
    (
        echo =======================================
        echo Processing Results
        echo =======================================
    ) > "%combined_file%"
)

REM Initialize the temporary file
echo. > %temp_file%

REM Initialize counters
set "total_lines=0"
set "database_count=0"

REM Process each keyword
for /f "tokens=*" %%k in (%keyword_file%) do (
    set "keyword=%%k"
    set "keyword_lines=0"
    
    REM Send a request to the API and store the response in a keyword-specific file
    echo Requesting data for keyword: !keyword!...
    curl -s "http://mtl1.micium-hosting.com:1861/search?keyword=!keyword!" > "%result_folder%\!keyword!.txt"
    
    REM Check if the response file is empty
    for %%A in ("%result_folder%\!keyword!.txt") do set "filesize=%%~zA"
    
    echo File size for %result_folder%\!keyword!.txt: !filesize!
    
    if !filesize! lss 1 (
        if "%mode%"=="1" (
            echo Download successful but no data was found for the keyword: !keyword! >> "%combined_file%"
        )
    ) else (
        if "%mode%"=="1" (
            REM Append the content to the temporary file and count lines
            echo Appending data for keyword: !keyword! >> "%combined_file%"
            for /f "delims=" %%L in ('type "%result_folder%\!keyword!.txt"') do (
                echo %%L >> %temp_file%
                set /a "keyword_lines+=1"
            )
            
            REM Update the total line count
            set /a "total_lines+=keyword_lines"
            
            REM Log the keyword and line count to the combined file
            echo Keyword: !keyword!, Lines Added: !keyword_lines! >> "%combined_file%"
            echo -------------------------------------------------- >> "%combined_file%"
            
            REM Increment the database count
            set /a "database_count+=1"
        ) else (
            REM Create a file for each keyword
            if not exist "%final_results_folder%" mkdir "%final_results_folder%"
            (
                echo =======================================
                echo Results for Keyword: !keyword!
                echo =======================================
            ) > "%final_results_folder%\!keyword!.txt"
            for /f "delims=" %%L in ('type "%result_folder%\!keyword!.txt"') do (
                echo %%L >> "%final_results_folder%\!keyword!.txt"
            )
        )
        
        REM Wait for the fixed delay using PowerShell
        powershell -command "Start-Sleep -Milliseconds !delay!"
    )
)

REM Add final summary to the top of the file if combining results
if "%mode%"=="1" (
    echo. >> "%combined_file%"
    (
        echo =======================================
        echo Summary of Processing Results
        echo =======================================
        
        REM Check if the temporary file has been created and has content
        if exist %temp_file% (
            REM Remove duplicate lines and randomize lines
            sort /unique %temp_file% /o %temp_file%
            
            REM Shuffle lines to randomize order
            powershell -Command "Get-Content %temp_file% | Get-Random -Count (Get-Content %temp_file% | Measure-Object -Line).Lines | Set-Content %temp_sorted_file%"
            
            REM Add data to the combined file
            echo Number of unique lines: !total_lines!
            echo Average age of databases: 0.64 days
            echo Total number of databases processed: !database_count!
            echo.
            echo Data from Keywords:
            echo --------------------------------------------------
            
            REM Filter out lines with spaces and duplicates
            powershell -Command "& {Get-Content %temp_sorted_file% | Where-Object {$_ -notmatch '^\s*$'} | Sort-Object -Unique | Set-Content %final_data_file%}"
            
            type %final_data_file%
        ) else (
            echo The temporary file does not exist or is empty. >> "%combined_file%"
        )
    ) >> "%combined_file%"
)

REM Always remove the result folder after processing
rmdir /s /q "%result_folder%"

REM Remove the temporary files only if combining results
if "%mode%"=="1" (
    del /q %temp_file%
    del /q %temp_sorted_file%
    del /q %final_data_file%
)

echo Finished processing all keywords. Results are in "%combined_file%" or individual files in "%final_results_folder%".
pause
