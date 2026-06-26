import re
import os

analysis_file = 'current_analysis4.txt'

fixes_by_file = {}

with open(analysis_file, 'r', encoding='utf-8') as f:
    for line in f:
        # Example: warning - lib\core\widgets\charts_widget.dart:42:11 - The value of the local variable 'isDark' isn't used. - unused_local_variable
        # Example: info - lib\features\bilan\presentation\widgets\bilan_overview_tab.dart:36:26 - Use 'const' with the constructor - prefer_const_constructors
        match = re.search(r'(warning|info)\s+-\s+([^\:]+):(\d+):(\d+)\s+-\s+.*-\s+(\w+)', line)
        if match:
            filepath = match.group(2).replace('\\', '/')
            line_num = int(match.group(3))
            col_num = int(match.group(4))
            rule = match.group(5)
            
            if filepath not in fixes_by_file:
                fixes_by_file[filepath] = []
                
            fixes_by_file[filepath].append({
                'line': line_num,
                'col': col_num,
                'rule': rule
            })

for filepath, fixes in fixes_by_file.items():
    if not os.path.exists(filepath):
        continue
        
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    # Sort fixes descending by line number so edits don't shift line numbers below them
    fixes.sort(key=lambda x: x['line'], reverse=True)
    
    modified = False
    for fix in fixes:
        line_idx = fix['line'] - 1
        rule = fix['rule']
        col_idx = fix['col'] - 1
        
        if rule in ['unused_import', 'unnecessary_import', 'unused_local_variable']:
            lines[line_idx] = '// ' + lines[line_idx] # Comment out the line
            modified = True
        elif rule in ['prefer_const_constructors', 'prefer_const_literals_to_create_immutables']:
            # Insert 'const ' at the specified column
            original_line = lines[line_idx]
            # Ensure we don't insert if it already has const
            if not original_line[max(0, col_idx-6):col_idx].strip().endswith('const'):
                lines[line_idx] = original_line[:col_idx] + "const " + original_line[col_idx:]
                modified = True
                
    if modified:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.writelines(lines)
            
print("Fixes applied successfully.")
