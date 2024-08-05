# Account Leeching Batch File

## Description

This batch file is designed to leech accounts or account combolist data from an API. It allows you to process multiple keywords, gather results, and save them into files. You can choose to combine all results into one file or create separate files for each keyword.

## How to Use

1. **Prepare Your Environment:**
   - Ensure you have `curl` and `powershell` installed on your system.
   - Place your keywords in a file named `keywords.txt`, with each keyword on a new line.

2. **Setup:**
   - Create a folder named `result` in the same directory as the batch file. This folder will be used to store temporary and final results.

3. **Run the Batch File:**
   - Execute the batch file by double-clicking it or running it from the command line.

4. **Select Output Mode:**
   - You will be prompted to choose the output mode:
     - **1:** Combine all results into one file.
     - **2:** Create separate files for each keyword.

5. **Review Results:**
   - If you chose to combine results (mode 1), the combined results will be saved in `combined.txt` in the `result` folder.
   - If you chose to create separate files (mode 2), individual files for each keyword will be saved in the `final_results` folder.

## API Documentation

The batch file interacts with the following API endpoint:

### Endpoint

```
http://mtl1.micium-hosting.com:1861/search?keyword={keyword}
```
### Parameters

- **keyword**: The search term or keyword for which data is being requested. This is specified in the `keywords.txt` file.

### Response

The API returns data related to the keyword. The data is saved into text files, one for each keyword.

### Example

For a keyword `example`, the batch file will send a request to:

```
http://mtl1.micium-hosting.com:1861/search?keyword=example
```

The response data will be saved in `result/example.txt`.

## File Structure

- **keywords.txt**: File containing keywords for data requests (one per line).
- **result/**: Folder for temporary files and combined results.
- **combined.txt**: Combined results file if mode 1 is selected.
- **final_results/**: Folder for individual files if mode 2 is selected.

## Notes

- The batch file includes a fixed delay of 300 milliseconds between API requests to avoid overwhelming the server.
- Temporary files and the result folder are cleaned up after processing to keep the directory organized.

## Example

1. **Prepare keywords.txt** with the following content
```
keywordexample1
keywordexample2
etc
```

2. **Run the batch file**. Choose output mode `1` to combine results into a single file.

3. **Check `combined.txt`** in the `result` folder for the processed data.

## Troubleshooting

- Ensure that `curl` is available in your system's PATH.
- Verify that `powershell` is installed and accessible.
- If no data is found for a keyword, check the API endpoint and ensure that the keyword is valid.

Feel free to modify the batch file according to your needs and add any additional features or improvements.

Happy leeching!
