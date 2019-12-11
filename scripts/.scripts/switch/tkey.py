import glob
import sys
import time
from binascii import unhexlify as uhx, hexlify as hx
from pathlib import Path
from struct import unpack as up, pack as pk

def read_at(fp, off, len):
    fp.seek(off)
    return fp.read(len)

def read_u8(fp, off):
    return up('<B', read_at(fp, off, 1))[0]

def read_u16(fp, off):
    return up('<H', read_at(fp, off, 2))[0]

def read_u32(fp, off):
    return up('<I', read_at(fp, off, 4))[0]

def read_u64(fp, off):
    return up('<Q', read_at(fp, off, 8))[0]

def read_str(fp, off, l):
    if l == 0:
        return ''
    s = read_at(fp, off, l)
    if '\0' in s:
        s = s[:s.index('\0')]
    return s

class PFS0:
    def __init__(self, path):
        self.path = path

        with open(path, 'rb') as f:
            self.magic = read_at(f, 0x0, 0x4)
            self.num_files = read_u32(f, 0x4)
            self.string_table_size = read_u32(f, 0x8)
            self.string_table_start = 0x10 + self.num_files * 0x18
            self.header_size = self.string_table_start + self.string_table_size
            self.raw_header = read_at(f, 0x0, self.header_size)

        if self.magic != b'PFS0':
            raise TypeError('Path provided is not of a PFS0.')

        self.file_entries = []

        # Create FileEntry instances from the raw header
        for i in range(self.num_files):
            entry_start_off = 0x10 + 0x18 * i
            data_offset = self.read_u64(entry_start_off)
            file_size = self.read_u64(entry_start_off+0x8)
            string_table_offset = self.read_u32(entry_start_off+0x10)

            self.file_entries.append(FileEntry(self, data_offset, file_size, string_table_offset))

    def get_file_entry_by_name(self, name):
        for entry in self.file_entries:
            if entry.get_name() == name:
                return entry
        return None

    def get_file_entry_by_extension(self, extension):
        for entry in self.file_entries:
            if entry.get_extension() == extension:
                return entry
        return None

    def read_at(self, off, len):
        return self.raw_header[off:off+len]

    def read_u8(self, off):
        return up('<B', self.raw_header[off:off+0x1])[0]

    def read_u16(self, off):
        return up('<H', self.raw_header[off:off+0x2])[0]

    def read_u32(self, off):
        return up('<I', self.raw_header[off:off+0x4])[0]

    def read_u64(self, off):
        return up('<Q', self.raw_header[off:off+0x8])[0]

    def read_str(self, off, l):
        if l == 0:
            return ''
        s = self.read_at(off, l)
        if b'\0' in s:
            s = s[:s.index(b'\0')].decode('utf-8')
        return s

class FileEntry:
    def __init__(self, owner, data_offset, file_size, string_table_offset):
        self.owner = owner
        self.data_offset = data_offset
        self.file_size = file_size
        self.string_table_offset = string_table_offset

    def get_name(self):
        return self.owner.read_str(self.owner.string_table_start + self.string_table_offset, 256)

    def get_extension(self):
        file_name = self.get_name()
        return file_name[file_name.index('.')+1:]

    def get_second_extension(self):
        extension = self.get_extension()
        second_extension = None
        try:
            second_extension = extension[extension.index('.')+1:]
        except:
            pass

        return second_extension

    def read_data(self):
        with open(self.owner.path, 'rb') as f:
            return read_at(f, self.owner.header_size + self.data_offset, self.file_size)

def print_nsp_info(path):
    nsp = PFS0(path)
    tik_entry = nsp.get_file_entry_by_extension('tik')

    if tik_entry is None:
        print('NSP is missing a tik file!')
        sys.exit()

    tik_data = tik_entry.read_data()
    title_key = hx(tik_data[0x180:0x190]).decode('utf-8')
    rights_id = hx(tik_data[0x2A0:0x2B0]).decode('utf-8')
    
    print('{}|{}|{}'.format(rights_id, title_key, path.stem))
    time.sleep(5)

def print_usage():
    print("""\
tkey.py

Get the title key from an nsp.

Usage: tkey.py <nsp file/directory containing nsps>""")

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print_usage()
        sys.exit(1)

    path_in = Path(sys.argv[1])

    print('Rights Id                       |Title Key                       |Name')

    if path_in.is_dir():
        for nsp_path in glob.iglob(path_in.absolute().__str__() + '**/*.nsp', recursive=True):
            try:
                print_nsp_info(Path(nsp_path))
            except TypeError:
                continue
    else:
        print_nsp_info(path_in)


