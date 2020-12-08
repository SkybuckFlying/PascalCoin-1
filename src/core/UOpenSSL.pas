unit UOpenSSL;

{ Copyright (c) 2016 by Albert Molina

  Distributed under the MIT software license, see the accompanying file LICENSE
  or visit http://www.opensource.org/licenses/mit-license.php.

  This unit is a part of the PascalCoin Project, an infinitely scalable
  cryptocurrency. Find us here:
  Web: https://www.pascalcoin.org
  Source: https://github.com/PascalCoin/PascalCoin

  Acknowledgements
  - Portions of this unit contains code from
    https://github.com/Arvur/OpenSSL-Delphi (unspecified license, public code)

  If you like it, consider a donation using Bitcoin:
  16K3HCZRhFUtM8GdWRcfKeaa6KsuyxZaYk

  THIS LICENSE HEADER MUST NOT BE REMOVED.
}

interface

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I ./../config.inc}

{$IFDEF ANDROID}
Uses UBaseTypes;
{$ENDIF}

var

{$IF Defined(UNIX) or Defined(ANDROID) or Defined(DARWIN)}
  SSL_C_LIB : String = 'libcrypto';
  {$IFDEF OpenSSL10}
  SSL_C_LIB_Versions : array [0..4] of string = ('','.10','.1.0.2','.1.0.1','.1.0.0');
  {$ELSE}
  SSL_C_LIB_Versions : array [0..2] of string = ('.1.1','.1.1.0','.1.1.1');
  {$ENDIF}
{$ELSE}
  // We are on Windows Systems
  SSL_C_LIB_Versions : array [0..0] of string = (''); // No versioning available
  {$IFDEF OpenSSL10}
    {$IF Defined(CPU64) or Defined(CPUX64)}
  SSL_C_LIB : String = 'libeay64';
// skybuck not sure, but maybe this was better, old version://    {$IFDEF FPC}
//      {$ifdef CPU32}
//      SSL_C_LIB : AnsiString = 'libeay32.dll';
//      {$ENDIF}
//      {$ifdef CPU64}
//      SSL_C_LIB : AnsiString = 'libeay64.dll';
//      {$ENDIF}
    {$ELSE}
  SSL_C_LIB : String = 'libeay32';
    {$ENDIF}
  {$ELSE}
    {$IF Defined(CPU64) or Defined(CPUX64)}
  SSL_C_LIB : String = 'libcrypto-1_1-x64';
    {$ELSE}
  SSL_C_LIB : String = 'libcrypto-1_1';
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

const
  SHA_LBLOCK                  = 16;
  RIPEMD160_CBLOCK            = 64;
  RIPEMD160_LBLOCK            = (RIPEMD160_CBLOCK div 4);
  PKCS5_SALT_LEN              = 8;
  EVP_MAX_MD_SIZE             = 64;
  SHA512_DIGEST_LENGTH        = 64;
  EVP_MAX_IV_LENGTH           = 16;
  EVP_MAX_BLOCK_LENGTH        = 32;
  POINT_CONVERSION_COMPRESSED = 2;
  //
  SN_secp256k1                = 'secp256k1';
  NID_secp256k1               = 714;
  SN_secp384r1                = 'secp384r1';
  NID_secp384r1               = 715;
  SN_sect283k1                = 'sect283k1';
  CT_NID_sect283k1            = 729;
  SN_secp521r1                = 'secp521r1';
  CT_NID_secp521r1            = 716;
type
  size_t = Word;
  qword = UInt64;
  PVOID = Pointer;
  TC_INT   = LongInt;
  PC_INT   = ^TC_INT;
  TC_UINT  = LongWord;
  PC_UINT  = ^TC_UINT;
  TC_LONG  = LongInt;
  PC_LONG = ^TC_LONG;
  TC_ULONG = LongWord;
  PC_ULONG = ^TC_ULONG;
  TC_ULONGLONG = qword;
  TC_time_t = TC_LONG;
  TC_USHORT = Word;
  PC_USHORT = ^TC_USHORT;
  TC_SIZE_T = LongWord;
  PC_SIZE_T = ^TC_SIZE_T;
  BN_ULONG = TC_ULONGLONG;
  PBN_ULONG = ^BN_ULONG;
  DES_LONG= TC_ULONG;
  PDES_LONG = ^DES_LONG;
  point_conversion_form_t = TC_UINT;
  TC_OSSL_SSIZE_T = TC_LONG;
  IDEA_INT = TC_UINT;
  MD4_LONG = TC_ULONG;
  MD5_LONG = TC_ULONG;
  RC2_INT = TC_UINT;
  RC4_INT = TC_UINT;
  RC5_32_INT = TC_ULONG;
  RIPEMD160_LONG = TC_ULONG;
  SHA_LONG = TC_ULONG;
  SHA_LONG64 = UInt64;
  PBN_CTX = Pointer;
  BIGNUM = record
    d : PBN_ULONG;
    top : TC_INT;
    dmax : TC_INT;
    neg : TC_INT;
    flags : TC_INT;
  end;
  PBIGNUM = ^BIGNUM;
  PPBIGNUM = ^PBIGNUM;
  PEC_KEY = Pointer;
  PPEC_KEY = ^PEC_KEY;
  PEC_GROUP = Pointer;
  PPEC_GROUP = ^PEC_GROUP;
  PEC_POINT = ^EC_POINT;
  PEC_METHOD = Pointer;
  EC_POINT = record
    meth: PEC_METHOD;
    X: BIGNUM;
    Y: BIGNUM;
    Z: BIGNUM;
    Z_is_one: TC_INT;
  end;
  PSHA256_CTX = ^SHA256_CTX;
  PPSHA256_CTX = ^PSHA256_CTX;
  SHA256_CTX = record
    _h: array[0..7] of SHA_LONG;
    _Nl,_Nh: SHA_LONG;
    _data: array[0..SHA_LBLOCK-1] of SHA_LONG;
    _num,_md_len: TC_UINT;
  end; { record }
  PRIPEMD160_CTX = ^RIPEMD160_CTX;
  PPRIPEMD160_CTX = ^PRIPEMD160_CTX;
  RIPEMD160_CTX = record
    _A,_B,_C,_D,_E: RIPEMD160_LONG;
    _Nl,_Nh: RIPEMD160_LONG;
    _data: array [0..RIPEMD160_LBLOCK-1] of RIPEMD160_LONG;
    _num: TC_UINT;
  end; { record }
  PECDSA_SIG = ^ECDSA_SIG;
  PPECDSA_SIG = ^PECDSA_SIG;
  ECDSA_SIG = record
      _r: PBIGNUM;
      _s: PBIGNUM;
  end; { record }
  EVP_MD_CTX = Pointer;
  PEVP_MD_CTX = ^EVP_MD_CTX;
  PPEVP_MD_CTX = ^PEVP_MD_CTX;
  PEVP_MD = ^EVP_MD;
  PPEVP_MD = ^PEVP_MD;
  PENGINE = Pointer;
  PPENGINE = ^PENGINE;
  PEVP_CIPHER = ^EVP_CIPHER;
  PPEVP_CIPHER = ^PEVP_CIPHER;
  EVP_CIPHER_CTX = Pointer;
  PEVP_CIPHER_CTX = ^EVP_CIPHER_CTX;
  PASN1_TYPE = Pointer;
  EVP_CIPHER = record
    nid : TC_Int;
    block_size : TC_Int;
    key_len : TC_Int;
    iv_len : TC_Int;
    flags : TC_ULONG;
    init : function (ctx : PEVP_CIPHER_CTX; key : PAnsiChar; iv : PAnsiChar; enc : TC_Int): TC_Int; cdecl;
    do_cipher : function (ctx : PEVP_CIPHER_CTX; _out : PAnsiChar; _in : PAnsiChar; inl : size_t) : TC_Int; cdecl;
    cleanup : function (_para1 : PEVP_CIPHER_CTX): TC_Int; cdecl;
    ctx_size : TC_Int;
    set_asn1_parameters : function (_para1 : PEVP_CIPHER_CTX; _para2 : PASN1_TYPE) : TC_Int; cdecl;
    get_asn1_parameters :function (_para1 : PEVP_CIPHER_CTX; _para2 :  PASN1_TYPE) : TC_Int; cdecl;
    ctrl : function (_para1 : PEVP_CIPHER_CTX; _type : TC_Int; arg : TC_Int;  ptr : Pointer): TC_Int; cdecl;
    app_data : Pointer;
  end;
  ecdh_kdf = function(const _in: Pointer; _inlen: TC_SIZE_T; _out: Pointer; var _outlen: TC_SIZE_T): pointer; cdecl;
  HMAC_CTX = Pointer;
  PHMAC_CTX = ^HMAC_CTX;
  PPHMAC_CTX = ^PHMAC_CTX;
  EVP_MD = record
    _type : TC_Int;
    pkey_type : TC_Int;
    md_size : TC_Int;
    flags : TC_ULONG;
    init : function (ctx : PEVP_MD_CTX) : TC_Int; cdecl;
    update : function (ctx : PEVP_MD_CTX; data : Pointer; count : size_t):TC_Int; cdecl;
    _final : function (ctx : PEVP_MD_CTX; md : PAnsiChar) : TC_Int; cdecl;
    copy : function (_to : PEVP_MD_CTX; from : PEVP_MD_CTX ) : TC_Int; cdecl;
    cleanup : function(ctx : PEVP_MD_CTX) : TC_Int; cdecl;
    sign : function(_type : TC_Int; m : PAnsiChar; m_length : TC_UINT;  sigret : PAnsiChar; siglen : TC_UINT; key : Pointer) : TC_Int; cdecl;
    verify : function(_type : TC_Int; m : PAnsiChar; m_length : PAnsiChar;  sigbuf : PAnsiChar; siglen : TC_UINT; key : Pointer) : TC_Int; cdecl;
    required_pkey_type : array [0..4] of TC_Int;
    block_size : TC_Int;
    ctx_size : TC_Int;
    md_ctrl: function( ctx: PEVP_MD_CTX; cmd: TC_INT; p1: TC_INT; p2: Pointer): TC_INT; cdecl;
  end;



var
  OpenSSL_version_num: function: TC_ULONG; cdecl = nil;

  ERR_get_error: function: TC_ULONG; cdecl = nil;
  ERR_error_string: function(e: TC_ULONG; _buf: PAnsiChar): PAnsiChar; cdecl = nil;
  ERR_clear_error: procedure; cdecl = nil;

  BN_CTX_new: function: PBN_CTX; cdecl = nil;
  BN_CTX_free: procedure(c: PBN_CTX) cdecl = nil;
  BN_num_bits: function(a: PBIGNUM): TC_INT; cdecl = nil;
  BN_bin2bn: function(s: PAnsiChar; len: TC_INT; ret: PBIGNUM): PBIGNUM; cdecl = nil;
  BN_bn2bin: function(a: PBIGNUM; _to: PAnsiChar): TC_INT; cdecl = nil;
  BN_new: function: PBIGNUM; cdecl = nil;
  BN_free: procedure(a: PBIGNUM); cdecl = nil;
  BN_bn2hex: function(const a: PBIGNUM): PAnsiChar; cdecl = nil;
  BN_bn2dec: function(const a: PBIGNUM): PAnsiChar;cdecl = nil;
  BN_hex2bn: function(a: PPBIGNUM; str: PAnsiChar): TC_INT; cdecl = nil;
  BN_add: function(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM): TC_INT; cdecl = nil;
  BN_mul: function(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  BN_sqr: function(r: PBIGNUM; a: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  BN_set_negative: procedure(b: PBIGNUM; n: TC_INT); cdecl = nil;
  BN_div: function(dv: PBIGNUM; rem: PBIGNUM; m: PBIGNUM; d: PBIGNUM; ctx : PBN_CTX): TC_INT; cdecl = nil;
  BN_nnmod: function(r: PBIGNUM; m: PBIGNUM; d: PBIGNUM; ctx: PBN_CTX ): TC_INT; cdecl = nil;
  BN_cmp: function(a: PBIGNUM; b: PBIGNUM): TC_INT; cdecl = nil;
  BN_copy: function(a: PBIGNUM;b: PBIGNUM): PBIGNUM; cdecl = nil;
  BN_lshift: function(r: PBIGNUM; a: PBIGNUM; n: TC_INT): TC_INT; cdecl = nil;
  BN_lshift1: function(r: PBIGNUM; a: PBIGNUM): TC_INT; cdecl = nil;
  BN_rshift: function(r: PBIGNUM; const a: PBIGNUM; n: TC_INT): TC_INT; cdecl = nil;
  BN_rshift1: function(r: PBIGNUM; const a: PBIGNUM): TC_INT; cdecl = nil;
  BN_clear: procedure(a: PBIGNUM); cdecl = nil;
  BN_dec2bn: function(a: PPBIGNUM; str: PAnsiChar): TC_INT; cdecl = nil;
  BN_set_word: function(a: PBIGNUM; w: BN_ULONG): TC_INT; cdecl = nil;
  BN_sub: function(r: PBIGNUM; a: PBIGNUM; b: PBIGNUM): TC_INT; cdecl = nil;
  BN_exp: function(r: PBIGNUM; a: PBIGNUM; p: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;

  EC_KEY_new: function: PEC_KEY; cdecl = nil;
  EC_KEY_free: procedure(key: PEC_KEY); cdecl = nil;
  EC_KEY_new_by_curve_name: function(nid: TC_INT): PEC_KEY; cdecl = nil;
  EC_KEY_generate_key: function(key: PEC_KEY): TC_INT; cdecl = nil;
  EC_KEY_get0_group: function(const key: PEC_KEY): PEC_GROUP; cdecl = nil;
  EC_KEY_get0_private_key: function(const key: PEC_KEY): PBIGNUM; cdecl = nil;
  EC_KEY_set_private_key: function(key: PEC_KEY; const prv: PBIGNUM): TC_INT; cdecl = nil;
  EC_KEY_get0_public_key: function(const key: PEC_KEY): PEC_POINT; cdecl = nil;
  EC_KEY_set_public_key: function(key: PEC_KEY; const pub: PEC_POINT): TC_INT; cdecl = nil;
  EC_KEY_set_group: function(key: PEC_KEY; group: PEC_GROUP): TC_INT; cdecl = nil;
  EC_KEY_check_key: function(key: PEC_KEY): TC_INT; cdecl = nil;
  EC_GROUP_new_by_curve_name: function(nid: TC_INT): PEC_GROUP; cdecl = nil;
  EC_GROUP_free: procedure (group: PEC_GROUP); cdecl = nil;
  EC_POINT_new: function(const group: PEC_GROUP): PEC_POINT; cdecl = nil;
  EC_POINT_free: procedure(point: PEC_POINT); cdecl = nil;
  EC_POINT_set_affine_coordinates_GFp: function( group: PEC_GROUP; p: PEC_POINT;     x: PBIGNUM;  y: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_get_affine_coordinates_GFp: function( group: PEC_GROUP;     p: PEC_POINT; x: PBIGNUM; y: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_mul: function( group: PEC_GROUP; r: PEC_POINT;  bn: PBIGNUM;  pq: PEC_POINT;  bm: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_point2oct: function( group: PEC_GROUP;  p: PEC_POINT; form: point_conversion_form_t; buf: PAnsiChar; len: TC_SIZE_T; ctx: PBN_CTX): TC_SIZE_T; cdecl = nil;
  EC_POINT_oct2point: function( group: PEC_GROUP; p: PEC_POINT;  buf: PAnsiChar; len: TC_SIZE_T; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_point2bn: function( group: PEC_GROUP;  point: PEC_POINT; form: point_conversion_form_t; b: PBIGNUM; ctx: PBN_CTX): PBIGNUM; cdecl = nil;
  EC_POINT_bn2point: function( group: PEC_GROUP;  b: PBIGNUM;    point: PEC_POINT; ctx: PBN_CTX): PEC_POINT; cdecl = nil;

  CRYPTO_free : procedure(ptr : Pointer) cdecl = nil;

  SHA256_Init: function(c: PSHA256_CTX): TC_INT; cdecl = nil;
  SHA256_Update: function(c: PSHA256_CTX; const data: Pointer; len: TC_SIZE_T): TC_INT; cdecl = nil;
  SHA256_Final: function(md: PAnsiChar; c: PSHA256_CTX): TC_INT; cdecl = nil;
  SHA256: function(const d: PAnsiChar; n: TC_SIZE_T;md: PAnsiChar): PAnsiChar; cdecl = nil;
  SHA256_Transform: procedure(c: PSHA256_CTX; const data: PAnsiChar); cdecl = nil;
  SHA512: function(const d: PAnsiChar; n: TC_SIZE_T;md: PAnsiChar): PAnsiChar; cdecl = nil;

  RIPEMD160_Init: function(_c: PRIPEMD160_CTX): TC_INT; cdecl = nil;
  RIPEMD160_Update: function(_c: PRIPEMD160_CTX; const _data: Pointer; _len: TC_SIZE_T): TC_INT; cdecl = nil;
  RIPEMD160_Final: function(_md: PAnsiChar; _c: PRIPEMD160_CTX): TC_INT; cdecl = nil;
  RIPEMD160: function(const _d: PAnsiChar; _n: TC_SIZE_T; _md: PAnsiChar): PAnsiChar; cdecl = nil;
  RIPEMD160_Transform: procedure(_c: PRIPEMD160_CTX; const _b: PAnsiChar); cdecl = nil;

  ECDSA_SIG_new: function: PECDSA_SIG; cdecl = nil;
  ECDSA_SIG_free: procedure(_sig: PECDSA_SIG); cdecl = nil;
  i2d_ECDSA_SIG: function(const _sig: PECDSA_SIG; _pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ECDSA_SIG: function(_sig: PPECDSA_SIG; const _pp: PPAnsiChar; _len: TC_LONG): PECDSA_SIG; cdecl = nil;
  ECDSA_do_sign: function(const _dgst: PAnsiChar; _dgst_len: TC_INT; _eckey: PEC_KEY): PECDSA_SIG; cdecl = nil;
  ECDSA_do_sign_ex: function(const _dgst: PAnsiChar; _dgstlen: TC_INT; const _kinv: PBIGNUM; const _rp: Pointer; _eckey: PEC_KEY): PECDSA_SIG; cdecl = nil;
  ECDSA_do_verify: function(const _dgst: PAnsiChar; _dgst_len: TC_INT; const _sig: PECDSA_SIG; _eckey: PEC_KEY): TC_INT; cdecl = nil;
  {$IFDEF OpenSSL10}
  {$ELSE}
  ECDSA_SIG_get0: procedure(const _sig : PECDSA_SIG; const pr: PPBIGNUM; const ps:PPBIGNUM);
  ECDSA_SIG_set0: function(_sig : PECDSA_SIG; r,s : PBIGNUM): TC_INT; cdecl = nil;
  {$ENDIF}
  ECDSA_size: function(const _eckey: PEC_KEY): TC_INT; cdecl = nil;
  ECDSA_sign_setup: function(_eckey: PEC_KEY; _ctx: PBN_CTX; _kinv: PPBIGNUM; _rp: PPBIGNUM): TC_INT; cdecl = nil;
  ECDSA_sign: function(_type: TC_INT; const _dgst: PAnsiChar; _dgstlen: TC_INT; _sig: PAnsiChar; var _siglen: TC_UINT; _eckey: PEC_KEY): TC_INT; cdecl = nil;
  ECDSA_sign_ex: function(_type: TC_INT; const _dgst: PAnsiChar; _dgstlen: TC_INT; _sig: PAnsiChar; var _siglen: TC_UINT; const _kinv: PBIGNUM;const _rp: PBIGNUM; _eckey: PEC_KEY): TC_INT; cdecl = nil;
  ECDSA_verify: function(_type: TC_INT; const _dgst: PAnsiChar; _dgstlen: TC_INT; const _sig: PAnsiChar; _siglen: TC_INT; _eckey: PEC_KEY): TC_INT; cdecl = nil;

  RAND_pseudo_bytes: function(buf: PAnsiChar; num: TC_INT): TC_INT; cdecl = nil;

  EVP_sha256: function: PEVP_MD; cdecl = nil;
  {$IFDEF OpenSSL10}
  EVP_MD_CTX_init: procedure(ctx: PEVP_MD_CTX); cdecl = nil;
  EVP_MD_CTX_cleanup: function(ctx: PEVP_MD_CTX): TC_INT; cdecl = nil;
  EVP_MD_CTX_create: function: PEVP_MD_CTX; cdecl = nil;
  EVP_MD_CTX_destroy: procedure(ctx: PEVP_MD_CTX); cdecl = nil;
  EVP_CIPHER_CTX_init: procedure(a: PEVP_CIPHER_CTX); cdecl = nil;
  EVP_CIPHER_CTX_cleanup: function(a: PEVP_CIPHER_CTX): TC_INT; cdecl = nil;
  {$ELSE}
  EVP_MD_CTX_new: function : PEVP_MD_CTX; cdecl = nil;
  EVP_MD_CTX_free: function(ctx: PEVP_MD_CTX): TC_INT; cdecl = nil;
  {$ENDIF}
  EVP_DigestInit_ex: function(ctx: PEVP_MD_CTX; const _type: PEVP_MD; impl: PENGINE): TC_INT; cdecl = nil;
  EVP_DigestUpdate: function(ctx: PEVP_MD_CTX;const d: Pointer; cnt: TC_SIZE_T): TC_INT; cdecl = nil;
  EVP_DigestFinal_ex: function(ctx: PEVP_MD_CTX;md: PAnsiChar;var s: TC_INT): TC_INT; cdecl = nil;
  EVP_aes_256_cbc: function: PEVP_CIPHER; cdecl = nil;
  EVP_CIPHER_CTX_free: procedure(a: PEVP_CIPHER_CTX); cdecl = nil;
  EVP_CIPHER_CTX_new: function: PEVP_CIPHER_CTX; cdecl = nil;
  EVP_DecryptInit: function(ctx: PEVP_CIPHER_CTX;const cipher: PEVP_CIPHER; const key: PAnsiChar; const iv: PAnsiChar): TC_INT; cdecl = nil;
  EVP_DecryptInit_ex: function(ctx: PEVP_CIPHER_CTX;const cipher: PEVP_CIPHER; impl: PENGINE; const key: PAnsiChar; const iv: PAnsiChar): TC_INT; cdecl = nil;
  EVP_DecryptUpdate: function(ctx: PEVP_CIPHER_CTX; _out: PAnsiChar; var outl: TC_INT; const _in: PAnsiChar; inl: TC_INT): TC_INT; cdecl = nil;
  EVP_DecryptFinal: function(ctx: PEVP_CIPHER_CTX; outm: PAnsiChar; var outl: TC_INT): TC_INT; cdecl = nil;
  EVP_EncryptInit: function(ctx: PEVP_CIPHER_CTX;const cipher: PEVP_CIPHER; const key: PAnsiChar; const iv: PAnsiChar): TC_INT; cdecl = nil;
  EVP_EncryptInit_ex: function(ctx: PEVP_CIPHER_CTX;const cipher: PEVP_CIPHER; impl: PENGINE;   const key: PAnsiChar; const iv: PAnsiChar): TC_INT; cdecl = nil;
  EVP_EncryptUpdate: function(ctx: PEVP_CIPHER_CTX; _out: PAnsiChar; var outl: TC_INT; const _in: PAnsiChar; inl: TC_INT): TC_INT; cdecl = nil;
  EVP_EncryptFinal_ex: function(ctx: PEVP_CIPHER_CTX; _out: PAnsiChar; var outl: TC_INT): TC_INT; cdecl = nil;
  EVP_EncryptFinal: function(ctx: PEVP_CIPHER_CTX; _out: PAnsiChar; var outl: TC_INT): TC_INT; cdecl = nil;
  EVP_CIPHER_CTX_block_size: function(const ctx: PEVP_CIPHER_CTX): TC_INT; cdecl = nil;
  EVP_md5: function: PEVP_MD; cdecl = nil;
  EVP_CIPHER_key_length: function(const cipher: PEVP_CIPHER): TC_INT; cdecl = nil;
  EVP_CIPHER_block_size: function(const cipher: PEVP_CIPHER): TC_INT; cdecl = nil;
  EVP_MD_size: function(const md: PEVP_MD): TC_INT; cdecl = nil;
  EVP_CIPHER_CTX_set_padding: function(c: PEVP_CIPHER_CTX; pad: TC_INT): TC_INT; cdecl = nil;
  EVP_DecryptFinal_ex: function(ctx: PEVP_CIPHER_CTX; outm: PAnsiChar; var outl: TC_INT): TC_INT; cdecl = nil;

  ECDH_compute_key: function(_out: Pointer; outlen: TC_SIZE_T; const _pub_key: PEC_POINT; _ecdh: PEC_KEY; KDF: ecdh_kdf): TC_INT; cdecl = nil;

  {$IFDEF OpenSSL10}
  HMAC_CTX_init: procedure(_ctx: PHMAC_CTX); cdecl = nil;
  HMAC_CTX_cleanup: procedure(_ctx: PHMAC_CTX); cdecl = nil;
  {$ELSE}
  HMAC_CTX_new: function : PHMAC_CTX; cdecl = nil;
  HMAC_CTX_free: procedure(_ctx: PHMAC_CTX); cdecl = nil;
  {$ENDIF}

  HMAC_Init: function(_ctx: PHMAC_CTX; const _key: Pointer; _len: TC_INT;const _md: PEVP_MD): TC_INT; cdecl = nil;
  HMAC_Init_ex: function(_ctx: PHMAC_CTX; const _key: Pointer; _len: TC_INT;const _md: PEVP_MD; _impl: PENGINE): TC_INT; cdecl = nil;
  HMAC_Update: function(_ctx: PHMAC_CTX; const _data: PAnsiChar; _len: TC_SIZE_T): TC_INT; cdecl = nil;
  HMAC_Final: function(_ctx: PHMAC_CTX; _md: PAnsiChar; var _len: TC_UINT): TC_INT; cdecl = nil;
  HMAC: function(const _evp_md: PEVP_MD; const _key: Pointer; _key_len: TC_INT; const _d: PAnsiChar; _n: TC_SIZE_T; _md: PAnsiChar; var _md_len: TC_UINT): PAnsiChar; cdecl = nil;
  HMAC_CTX_copy: function(_dctx: PHMAC_CTX; _sctx: PHMAC_CTX): TC_INT; cdecl = nil;
  HMAC_CTX_set_flags: procedure(_ctx: PHMAC_CTX; _flags: TC_ULONG); cdecl = nil;

function SSLCryptHandle: THandle;
function LoadSSLCrypt: Boolean;
function LoadFunctionCLib(const FceName: String; const ACritical : Boolean = True): Pointer;
function InitSSLFunctions : Boolean;
function BN_num_bytes(a: PBIGNUM): TC_INT;
procedure OpenSSL_free(ptr: Pointer);
function OpenSSLVersion : Cardinal;
function CaptureLastSSLError : String;
function GetOpenSSLLibraryName : String;

implementation

uses {$IFDEF UNIX}dynlibs,{$ENDIF}
  {$IFDEF MSWINDOWS} windows,{$ENDIF}
  sysutils;

var hCrypt: THandle = 0;
  _LibraryName : String = '';

function GetOpenSSLLibraryName : String;
begin
  Result := _LibraryName;
end;


function SSLCryptHandle: THandle;
begin
  Result := hCrypt;
end;


function TryToLoadLibrary(const ALibName : String; const ALibVersions : array of String) : HMODULE;
  function GetLibName(const APath, AVersion : String) : String;
  var LExtension : String;
  begin
    {$IF Defined(IOS) or Defined(DARWIN)}
    LExtension := '.dylib';
    Result := APath+ALibName+AVersion+LExtension;
    {$ELSE}
      {$IF Defined(UNIX) or Defined(ANDROID)}
    LExtension := '.so';
    Result := APath+ALibName+LExtension+AVersion;
      {$ELSE}
    LExtension := '.dll';
    Result := APath+ALibName+AVersion+LExtension;
      {$ENDIF}
    {$ENDIF}
  end;
var
  i,jRound : Integer;
  LPath : String;
begin
  Result := 0;
  // First round will try to load library on same folder than app
  for jRound := 1 to 2 do begin
    if jRound=1 then LPath := '.'+PathDelim
    else LPath := ''; // Second round, no Path (OS will search)
    for i := Low(ALibVersions) to High(ALibVersions) do begin
      _LibraryName := GetLibName(LPath,ALibVersions[i]);
      {$IFDEF FPC}
      Result := LoadLibrary(PAnsiChar(_LibraryName));
      {$ELSE}
      Result := LoadLibrary(PWideChar(_LibraryName));
      {$ENDIF}
      if Result <> 0 then begin
        Exit;
      end else _LibraryName := '';
    end;
  end;
end;

function LoadSSLCrypt: Boolean;
begin
  If hCrypt=0 then begin
    hCrypt := TryToLoadLibrary(SSL_C_LIB,SSL_C_LIB_Versions);
  end;
  Result := hCrypt <> 0;
end;

function OpenSSLVersion : Cardinal;
begin
  if Assigned(OpenSSL_version_num) then Result := OpenSSL_version_num
  else Result := 0;
end;

function LoadFunctionCLib(const FceName: String; const ACritical : Boolean = True): Pointer;
begin
  if SSLCryptHandle = 0 then begin
    LoadSSLCrypt;
  end;
  {$IFDEF UNIX}
  Result := GetProcAddress(SSLCryptHandle, AnsiString(FceName));
  {$ELSE}
  Result := {Windows.}GetProcAddress(SSLCryptHandle, PChar(FceName));
  {$ENDIF}
  if ACritical then begin
    if Result = nil then begin
    {$IFDEF FPC}
     raise Exception.CreateFmt('Error loading OpenSSL library function "%s" error: "%s". Are you sure that using OpenSSL good version?', [FceName, SysErrorMessage(GetLastOSError)]);
    {$ELSE}
     raise Exception.CreateFmt('Error loading OpenSSL library function "%s" error: "%s". Are you sure that using OpenSSL good version?', [FceName, SysErrorMessage(GetLastError)]);
    {$ENDIF}
    end;
  end;
end;

function InitSSLFunctions : Boolean;
Begin
  If not LoadSSLCrypt then begin
    result := false;
    exit;
  end else result := true;
  if @OpenSSL_version_num=nil then begin
    // Important note: Only OpenSSL v1.1 has function "OpenSSL_version_num"
    @OpenSSL_version_num := LoadFunctionCLib('OpenSSL_version_num',False);
    if Not Assigned(OpenSSL_version_num) then begin
      {$IFNDEF OpenSSL10}
      Raise Exception.Create('PascalCoin needs OpenSSL v1.1, your current DLL is lower version: '+SSL_C_LIB);
      {$ENDIF}
    end;
  end;
  if @ERR_get_error = nil then begin
    @ERR_get_error:= LoadFunctionCLib('ERR_get_error');
    @ERR_clear_error:= LoadFunctionCLib('ERR_clear_error');
    @ERR_error_string:= LoadFunctionCLib('ERR_error_string');
    @BN_CTX_new:= LoadFunctionCLib('BN_CTX_new');
    @BN_CTX_free:= LoadFunctionCLib('BN_CTX_free');
    @BN_num_bits:= LoadFunctionCLib('BN_num_bits');
    @BN_bin2bn:= LoadFunctionCLib('BN_bin2bn');
    @BN_bn2bin:= LoadFunctionCLib('BN_bn2bin');
    @BN_new:= LoadFunctionCLib('BN_new');
    @BN_free:= LoadFunctionCLib('BN_free');
    @BN_bn2hex:= LoadFunctionCLib('BN_bn2hex');
    @BN_bn2dec:= LoadFunctionCLib('BN_bn2dec');
    @BN_hex2bn:= LoadFunctionCLib('BN_hex2bn');
    @BN_add:= LoadFunctionCLib('BN_add');
    @BN_mul:= LoadFunctionCLib('BN_mul');
    @BN_sqr:= LoadFunctionCLib('BN_sqr');
    @BN_set_negative:= LoadFunctionCLib('BN_set_negative');
    @BN_div:= LoadFunctionCLib('BN_div');
    @BN_nnmod:= LoadFunctionCLib('BN_nnmod');
    @BN_cmp:= LoadFunctionCLib('BN_cmp');
    @BN_copy:= LoadFunctionCLib('BN_copy');
    @BN_lshift:= LoadFunctionCLib('BN_lshift');
    @BN_lshift1:= LoadFunctionCLib('BN_lshift1');
    @BN_rshift:= LoadFunctionCLib('BN_rshift');
    @BN_rshift1:= LoadFunctionCLib('BN_rshift1');
    @BN_clear:= LoadFunctionCLib('BN_clear');
    @BN_dec2bn:= LoadFunctionCLib('BN_dec2bn');
    @BN_set_word:= LoadFunctionCLib('BN_set_word');
    @BN_sub:= LoadFunctionCLib('BN_sub');
    @BN_exp:= LoadFunctionCLib('BN_exp');
    @EC_KEY_new := LoadFunctionCLib('EC_KEY_new');
    @EC_KEY_free := LoadFunctionCLib('EC_KEY_free');
    @EC_KEY_new_by_curve_name:= LoadFunctionCLib('EC_KEY_new_by_curve_name');
    @EC_KEY_generate_key := LoadFunctionCLib('EC_KEY_generate_key');
    @EC_KEY_get0_group:= LoadFunctionCLib('EC_KEY_get0_group');
    @EC_KEY_get0_private_key:= LoadFunctionCLib('EC_KEY_get0_private_key');
    @EC_KEY_set_private_key:= LoadFunctionCLib('EC_KEY_set_private_key');
    @EC_KEY_get0_public_key:= LoadFunctionCLib('EC_KEY_get0_public_key');
    @EC_KEY_set_public_key:= LoadFunctionCLib('EC_KEY_set_public_key');
    @EC_KEY_set_group := LoadFunctionCLib('EC_KEY_set_group');
    @EC_KEY_check_key := LoadFunctionCLib('EC_KEY_check_key');
    @EC_GROUP_new_by_curve_name := LoadFunctionCLib('EC_GROUP_new_by_curve_name');
    @EC_GROUP_free := LoadFunctionCLib('EC_GROUP_free');
    @EC_POINT_new:= LoadFunctionCLib('EC_POINT_new');
    @EC_POINT_free:= LoadFunctionCLib('EC_POINT_free');
    @EC_POINT_set_affine_coordinates_GFp:= LoadFunctionCLib('EC_POINT_set_affine_coordinates_GFp');
    @EC_POINT_get_affine_coordinates_GFp:= LoadFunctionCLib('EC_POINT_get_affine_coordinates_GFp');
    @EC_POINT_mul:= LoadFunctionCLib('EC_POINT_mul');
    @EC_POINT_point2oct:= LoadFunctionCLib('EC_POINT_point2oct');
    @EC_POINT_oct2point:= LoadFunctionCLib('EC_POINT_oct2point');

    @SHA256_Init:= LoadFunctionCLib('SHA256_Init');
    @SHA256_Update:= LoadFunctionCLib('SHA256_Update');
    @SHA256_Final:= LoadFunctionCLib('SHA256_Final');
    @SHA256:= LoadFunctionCLib('SHA256');
    @SHA256_Transform:= LoadFunctionCLib('SHA256_Transform');
    @SHA512:= LoadFunctionCLib('SHA512');

    @RIPEMD160:= LoadFunctionCLib('RIPEMD160');

    @ECDSA_SIG_new:= LoadFunctionCLib('ECDSA_SIG_new');
    @ECDSA_SIG_free:= LoadFunctionCLib('ECDSA_SIG_free');
    @i2d_ECDSA_SIG:= LoadFunctionCLib('i2d_ECDSA_SIG');
    @d2i_ECDSA_SIG:= LoadFunctionCLib('d2i_ECDSA_SIG');
    @ECDSA_do_sign:= LoadFunctionCLib('ECDSA_do_sign');
    @ECDSA_do_sign_ex:= LoadFunctionCLib('ECDSA_do_sign_ex');
    @ECDSA_do_verify:= LoadFunctionCLib('ECDSA_do_verify');
    {$IFDEF OpenSSL10}
    {$ELSE}
    @ECDSA_SIG_get0:= LoadFunctionCLib('ECDSA_SIG_get0');
    @ECDSA_SIG_set0:= LoadFunctionCLib('ECDSA_SIG_set0');
    {$ENDIF}
    @ECDSA_size:= LoadFunctionCLib('ECDSA_size');
    @ECDSA_sign_setup:= LoadFunctionCLib('ECDSA_sign_setup');
    @ECDSA_sign:= LoadFunctionCLib('ECDSA_sign');
    @ECDSA_sign_ex:= LoadFunctionCLib('ECDSA_sign_ex');
    @ECDSA_verify:= LoadFunctionCLib('ECDSA_verify');

    @RAND_pseudo_bytes:= LoadFunctionCLib('RAND_pseudo_bytes');

    @EVP_sha256:= LoadFunctionCLib('EVP_sha256');
    {$IFDEF OpenSSL10}
    @EVP_MD_CTX_init:= LoadFunctionCLib('EVP_MD_CTX_init');
    @EVP_MD_CTX_cleanup:= LoadFunctionCLib('EVP_MD_CTX_cleanup');
    @EVP_MD_CTX_create:= LoadFunctionCLib('EVP_MD_CTX_create');
    @EVP_MD_CTX_destroy:= LoadFunctionCLib('EVP_MD_CTX_destroy');
    @EVP_CIPHER_CTX_init:= LoadFunctionCLib('EVP_CIPHER_CTX_init');
    @EVP_CIPHER_CTX_cleanup:= LoadFunctionCLib('EVP_CIPHER_CTX_cleanup');
    {$ELSE}
    @EVP_MD_CTX_new:= LoadFunctionCLib('EVP_MD_CTX_new');
    @EVP_MD_CTX_free:= LoadFunctionCLib('EVP_MD_CTX_free');
    {$ENDIF}
    @EVP_DigestInit_ex:= LoadFunctionCLib('EVP_DigestInit_ex');
    @EVP_DigestUpdate:= LoadFunctionCLib('EVP_DigestUpdate');
    @EVP_DigestFinal_ex:= LoadFunctionCLib('EVP_DigestFinal_ex');
    @EVP_aes_256_cbc:= LoadFunctionCLib('EVP_aes_256_cbc');
    @EVP_CIPHER_CTX_free:= LoadFunctionCLib('EVP_CIPHER_CTX_free');
    @EVP_CIPHER_CTX_new:= LoadFunctionCLib('EVP_CIPHER_CTX_new');
    @EVP_DecryptInit:= LoadFunctionCLib('EVP_DecryptInit');
    @EVP_DecryptInit_ex:= LoadFunctionCLib('EVP_DecryptInit_ex');
    @EVP_DecryptUpdate:= LoadFunctionCLib('EVP_DecryptUpdate');

    @EVP_DecryptFinal:= LoadFunctionCLib('EVP_DecryptFinal',False);
    if (Not Assigned(@EVP_DecryptFinal)) then
      EVP_DecryptFinal:= LoadFunctionCLib('EVP_DecryptFinal_ex');

    @EVP_EncryptInit:= LoadFunctionCLib('EVP_EncryptInit');
    @EVP_EncryptInit_ex:= LoadFunctionCLib('EVP_EncryptInit_ex');
    @EVP_EncryptUpdate:= LoadFunctionCLib('EVP_EncryptUpdate');
    @EVP_EncryptFinal_ex:= LoadFunctionCLib('EVP_EncryptFinal_ex');
    @EVP_EncryptFinal:= LoadFunctionCLib('EVP_EncryptFinal',False);
    if (Not Assigned(@EVP_DecryptFinal)) then
      EVP_EncryptFinal:=EVP_EncryptFinal_ex;

    @EVP_CIPHER_CTX_block_size:= LoadFunctionCLib('EVP_CIPHER_CTX_block_size');
    @EVP_md5:= LoadFunctionCLib('EVP_md5');
    @EVP_CIPHER_key_length:= LoadFunctionCLib('EVP_CIPHER_key_length');
    @EVP_CIPHER_block_size:= LoadFunctionCLib('EVP_CIPHER_block_size');
    @EVP_MD_size:= LoadFunctionCLib('EVP_MD_size');
    @EVP_CIPHER_CTX_set_padding:= LoadFunctionCLib('EVP_CIPHER_CTX_set_padding');
    @EVP_DecryptFinal_ex:= LoadFunctionCLib('EVP_DecryptFinal_ex');
    @ECDH_compute_key:= LoadFunctionCLib('ECDH_compute_key');

    {$IFDEF OpenSSL10}
    @HMAC_CTX_init:= LoadFunctionCLib('HMAC_CTX_init');
    @HMAC_CTX_cleanup:= LoadFunctionCLib('HMAC_CTX_cleanup');
    {$ELSE}
    @HMAC_CTX_new:= LoadFunctionCLib('HMAC_CTX_new');
    @HMAC_CTX_free:= LoadFunctionCLib('HMAC_CTX_free');
    {$ENDIF}
    @HMAC_Init:= LoadFunctionCLib('HMAC_Init');
    @HMAC_Init_ex:= LoadFunctionCLib('HMAC_Init_ex');
    @HMAC_Update:= LoadFunctionCLib('HMAC_Update');
    @HMAC_Final:= LoadFunctionCLib('HMAC_Final');
    @HMAC:= LoadFunctionCLib('HMAC');
    @HMAC_CTX_copy:= LoadFunctionCLib('HMAC_CTX_copy');

    @CRYPTO_free := LoadFunctionCLib('CRYPTO_free',False);
    if (Not Assigned(@CRYPTO_free)) then
      @CRYPTO_free := LoadFunctionCLib('OPENSSL_free',False);
  end;
End;

function BN_num_bytes(a: PBIGNUM): TC_INT;
begin
  Result := (BN_num_bits(a)+7) div 8;
end;

procedure OpenSSL_free(ptr: Pointer);
begin
  if @CRYPTO_Free <> nil then begin
    CRYPTO_free(ptr);
  end;
end;

function CaptureLastSSLError : String;
begin
  {$IFDEF NO_ANSISTRING}
  Result := UBaseTypes.StrPas(ERR_error_string(ERR_get_error(),nil));
  {$ELSE}
  Result := ERR_error_string(ERR_get_error(),nil);
  {$ENDIF}
end;

initialization

finalization
  if hCrypt <> 0 then begin
    FreeLibrary(hCrypt);
  end;
end.

