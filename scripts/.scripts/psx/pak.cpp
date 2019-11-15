#include <iostream>
#include <string.h>
#include <sys/stat.h>

#define PACK_MAGIC 0x726b7066 // rpkf

// WTF is KUL?
#pragma pack(push, 1)
struct KUL_PackHeader // 0x10
{
	uint32_t magic;		// 0x00
	uint16_t version;	// 0x04
	uint16_t unk;		// 0x06
	uint32_t pagesize;	// 0x08
	uint32_t files;		// 0x0C
};

struct KUL_PackFileHeader // 0x120
{
	uint32_t flags;		// 0x10
	uint32_t page;		// 0x14
	uint32_t size;		// 0x18
	uint32_t magic;		// 0x1C
	uint32_t unk1;		// 0x20
	uint32_t crc;		// 0x24
	uint32_t unk3;		// 0x28
	uint32_t unk4;		// 0x2C
	uint8_t namelen;	// 0x30
	char name[255];		// 0x31
};
#pragma pack(pop)

void pseudoDES(uint32_t* pword0, uint32_t* pword1)
{
	uint32_t iswap, ia, iah, ial, ib, ic;
	static uint32_t c1[4] = { 0xbaa96887, 0x1e17d32c, 0x03bcdc3c, 0x0f33d1b2 };
	static uint32_t c2[4] = { 0x4b0f3b58, 0xe874f0c3, 0x6955c5a6, 0x55a7ca46 };

	for (int i = 0; i < 4; i++)
	{
		iswap = *pword1;
		ia = iswap ^ c1[i];
		ial = ia & 0xffff;
		iah = ia >> 0x10;
		ib = ial * ial + ~(iah * iah);
		ic = (ib >> 16) | ((ib & 0xffff) << 16);
		*pword1 = *pword0 ^ (ic ^ c2[i]) + ial * iah;
		*pword0 = iswap;
	}
}

int KUL_Rand_PDES(int* phiword, int* ploword)
{
	int loword;
	int hiword;

	hiword = *phiword;
	if (hiword < 0)
	{
		*ploword = -hiword;
		*phiword = 1;
		hiword = 1;
	}
	loword = *ploword;

	pseudoDES((uint32_t*) &loword, (uint32_t *) &hiword);

	++*phiword;
	return hiword;
}

uint8_t KUL_Decrypt(uint8_t *src, uint32_t size, int zero, uint32_t* seed)
{
	if (zero != 0)
		return -1;

	uint32_t i = 0;
	if (size != 0)
	{
		uint8_t rndByte[4];
		for (int i = 0; i < size; i++)
		{
			if ((i & 3) == 0)
			{
				uint32_t rnd = KUL_Rand_PDES((int *)seed, (int*)&seed[1]);
				rndByte[0] = (uint8_t) (rnd >> 3);
				rndByte[1] = (uint8_t) (rnd >> 2);
				rndByte[2] = (uint8_t) (rnd >> 1);
				rndByte[3] = (uint8_t) rnd;
			}
			src[i] ^= rndByte[i & 3];
		}
	}

	return 0;
}

void decryptHeader(KUL_PackHeader *header)
{
	uint32_t seed[2] = { 0x80000000 | 9999999, 0 };
	KUL_Decrypt((uint8_t *) &header->unk, 2, 0, seed);
	KUL_Decrypt((uint8_t *) &header->pagesize, 4, 0, seed);
	KUL_Decrypt((uint8_t *) &header->files, 4, 0, seed);
	return;
}

uint32_t crc(uint8_t* data, uint32_t size)
{
	uint8_t c;
	int left;

	uint32_t table[0x100];
	
	for (int i = 0; i < 0x100; i++)
	{
		uint32_t x = i;
		for (int j = 7; -1 < j; --j)
		{
			if ((x & 1) == 0)
				x = x >> 1;
			else
				x = x >> 1 ^ 0xedb88320;
		}
		table[i] = x;
	}
	uint32_t crc = 0xffffffff;

	left = (int)size + -1;
	if (size != 0) {
		do {
			c = *data;
			data = data + 1;
			left = left + -1;
			crc = crc >> 8 ^ table[(crc & 0xff) ^ c];
		} while (left != -1);
	}

	return ~crc;
}

int main(int argc, char** argv)
{
	if (argc != 3)
	{
		printf("%s: <PAK file> <output folder>\n", argv[0]);
		return 1;
	}

	KUL_PackHeader header;
	FILE* f = fopen(argv[1], "rb");
	fread(&header, sizeof(header), 1, f);
	
	if (__bswap_16(header.version) > 1)
		decryptHeader(&header);

	if (header.magic != PACK_MAGIC)
	{
		printf("Invaild file magic!\n");
		fclose(f);
		return 1;
	}

	KUL_PackFileHeader*files = new KUL_PackFileHeader[header.files];
	fread(files, sizeof(KUL_PackFileHeader), header.files, f);

	if (__bswap_16(header.version) != 0)
	{
		uint32_t seed[2] = { 0x80000000 | header.files, 0 };
		for (int i = 0; i < header.files; i++)
		{
			KUL_Decrypt((uint8_t*) &files[i], sizeof(KUL_PackFileHeader), 0, seed);
		}
	}

	for (int i = 0; i < header.files; i++)
	{
		printf("%s\n", files[i].name);
		/*printf("\tencrypted:%s\n", (files[i].flags & 0x80000000) ? "true" : "false");
		printf("\toffset: %x\n", files[i].page * header.pagesize);
		printf("\tsize: %x\n", files[i].size);*/

		uint8_t* data = new uint8_t[files[i].size];
		fseek(f, files[i].page * header.pagesize, SEEK_SET);
		fread(data, 1, files[i].size, f);

		if (files[i].flags & 0x80000000)
		{
			uint32_t seed[2] = { 0x80000000 | files[i].size, 0 };
			KUL_Decrypt(data, files[i].size, 0, seed);
		}

		if (files[i].crc != crc(data, files[i].size))
		{
			printf("INVALID CRC!\n");
			break;
		}

		char str[1024];
		memset(str, 0, sizeof(str));
		strcat(str, argv[2]);
		strcat(str, "/");
		strncpy(&str[strlen(argv[2]) + 1], files[i].name, files[i].namelen);
		for (int j = 0; j < strlen(str); j++)
		{
			if (j + 1 < strlen(str) && str[j] == '.' && str[j + 1] == '.')
			{
				str[j] = '_';
				++j;
				str[j] = '_';
			}
		}

		for (char* end = strchr(str, '/'); end != NULL; end = strchr(++end, '/'))
		{
			char folder[1024];
			memset(folder, 0, sizeof(folder));
			strncpy(folder, str, end - str + 1);
			mkdir(folder, 0744);
		}

		FILE* fo = fopen(str, "wb");
		fwrite(data, 1, files[i].size, fo);
		fclose(fo);

		delete[] data;
	}

	delete[] files;

	fclose(f);
	return 0;
}
