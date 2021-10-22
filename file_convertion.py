def decimalToBinary(n):
    return "{0:b}".format(int(n))
    
f = open('spi_cmds_simple.csv', 'r')
f_new = open('data.mem', 'w')
next(f)

for line in f:
    line = line.rstrip('\n')
    string_list = line.split(',')
    print(string_list)
    string_list[0] = decimalToBinary(string_list[0]).zfill(16)
    string_list[1] = decimalToBinary(string_list[1]).zfill(8)
    res = ",".join(string_list) + "\n"
    res = res.replace(',', '')
    f_new.write(res)
    
    print(string_list)
    #p2 = bin(string_list[1])
    #print(p1)
    #print(p2)

f.close()
