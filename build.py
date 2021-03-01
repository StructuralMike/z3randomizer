import bsdiff4
import yaml
import lzma
import os
import sys
import hashlib
from typing import Optional

from asar import init as asar_init, close as asar_close, patch as asar_patch, geterrors as asar_errors, getprints as asar_prints, getwarnings as asar_warnings

JAP10HASH = '03a63945398191337e896e5771f77173'

try:
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Loader


def int16_as_bytes(value):
    value = value & 0xFFFF
    return [value & 0xFF, (value >> 8) & 0xFF]


def int32_as_bytes(value):
    value = value & 0xFFFFFFFF
    return [value & 0xFF, (value >> 8) & 0xFF, (value >> 16) & 0xFF, (value >> 24) & 0xFF]


def is_bundled():
    return getattr(sys, 'frozen', False)


def local_path(path):
    if local_path.cached_path:
        return os.path.join(local_path.cached_path, path)

    elif is_bundled():
        if hasattr(sys, "_MEIPASS"):
            # we are running in a PyInstaller bundle
            local_path.cached_path = sys._MEIPASS  # pylint: disable=protected-access,no-member
        else:
            # cx_Freeze
            local_path.cached_path = os.path.dirname(os.path.abspath(sys.argv[0]))
    else:
        # we are running in a normal Python environment
        import __main__
        local_path.cached_path = os.path.dirname(os.path.abspath(__main__.__file__))

    return os.path.join(local_path.cached_path, path)


local_path.cached_path = None

    
def generate_yaml(patch: bytes, metadata: Optional[dict] = None) -> bytes:
    patch = yaml.dump({"meta": metadata,
                       "patch": patch,
                       "game": "alttp",
                       "base_checksum": JAP10HASH})
    return patch.encode(encoding="utf-8-sig")
    
def generate_patch(baserombytes: bytes, rom: bytes) -> bytes:
    patch = bsdiff4.diff(bytes(baserombytes), rom)
    return generate_yaml(patch, {})
    
def write_lzma(data: bytes, path: str):
    with lzma.LZMAFile(path, 'wb') as f:
        f.write(data)


if __name__ == '__main__':
    try:
        asar_init()
        print("Asar DLL initialized")
        
        print("Opening Base rom")
        with open('../alttp.sfc', 'rb') as stream:
            old_rom_data = bytearray(stream.read())
            
        if len(old_rom_data) % 0x400 == 0x200:
            old_rom_data = old_rom_data[0x200:]
            
        basemd5 = hashlib.md5()
        basemd5.update(old_rom_data)
        if JAP10HASH != basemd5.hexdigest():
            raise Exception("Base rom is not 'Zelda no Densetsu - Kamigami no Triforce (J) (V1.0)'")
            
        print("Patching Base Rom")
        result, new_rom_data = asar_patch(os.path.abspath('LTTP_RND_GeneralBugfixes.asm'), old_rom_data)
        
        if result:
            with open('../basepatch.sfc', 'wb') as stream:
                stream.write(new_rom_data)
            print("Success\n")
            basemd5 = hashlib.md5()
            basemd5.update(new_rom_data)
            print("New Rom Hash: " + basemd5.hexdigest())
            prints = asar_prints()
            for p in prints:
                print(p)
            write_lzma(generate_patch(old_rom_data, new_rom_data), "basepatch.bmbp")
        else:
            errors = asar_errors()
            print("\nErrors: " + str(len(errors)))
            for error in errors:
                print (error)
        warnings = asar_warnings()
        print("\nWarnings: " + str(len(warnings)))
        for w in warnings:
            print(w)
        
        asar_close()
    except:
        import traceback
        traceback.print_exc()

