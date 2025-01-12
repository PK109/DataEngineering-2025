import sys
import pandas as pd

print(pd.__version__)

param = sys.argv[1]
print(f"Job finished successfully with parameter: {param}")