from assembler import to_signed_binary

def test_to_signed_binary():
    assert to_signed_binary(0, 4) == '0000'
    assert to_signed_binary(7, 4) == '0111'
    assert to_signed_binary(-7, 4) == '1001'
    assert to_signed_binary(15, 4) == '1111'
    assert to_signed_binary(-15, 4) == '0001'
    assert to_signed_binary(8, 4) == '1000'
    assert to_signed_binary(-8, 4) == '1000'
    assert to_signed_binary(127, 8) == '01111111'
    assert to_signed_binary(-127, 8) == '10000001'
    assert to_signed_binary(128, 8) == '10000000'
    assert to_signed_binary(-128, 8) == '10000000'
    assert to_signed_binary(255, 8) == '11111111'
    assert to_signed_binary(-255, 8) == '00000001'
    assert to_signed_binary(256, 9) == '100000000'
    assert to_signed_binary(-256, 9) == '100000000'
    assert to_signed_binary(32767, 16) == '0111111111111111'
    assert to_signed_binary(-32767, 16) == '1000000000000001'
    assert to_signed_binary(32768, 16) == '1000000000000000'
    assert to_signed_binary(-32768, 16) == '1000000000000000'
    assert to_signed_binary(65535, 16) == '1111111111111111'
    assert to_signed_binary(-65535, 16) == '0000000000000001'
    assert to_signed_binary(65536, 16) == '0000000000000000'
    assert to_signed_binary(-65536, 16) == '0000000000000000'

test_to_signed_binary()