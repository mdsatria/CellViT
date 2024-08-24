import os
import pathlib


def make_list(path_in, f_out="input", start=0, end=-1, idjob=0):
    lst = sorted([pathlib.Path(x).stem for x in os.listdir(path_in)])
    with open(f"{f_out}{idjob}.txt", "w") as file:
        if end == -1:
            for l in lst:
                file.writelines(f"{l}\n")
        elif end == -2:
            for l in lst[start:]:
                file.writelines(f"{l}\n")
        else:
            for l in lst[start:end]:
                file.writelines(f"{l}\n")


cohort = ""
path = f"/home/some_paths/wsi/{cohort}"
make_list(path_in=path, f_out=f"file_lists/{cohort}", start=2100, end=-2, idjob=7)
