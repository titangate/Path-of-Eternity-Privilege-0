import socket,time

udp_ip = 'localhost'
udp_port = 12345
sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
#IR_l,IR_r = 1,1

def sendCmd(cmd,*para):
	s = ','.join(map(str,para))
	sock.sendto('{0}({1})'.format(cmd,s),(udp_ip,udp_port))

def forward(speed):
	sendCmd('forward',speed)

def motors(*para):
	sendCmd('motors',*para)

def stop():
	sendCmd('stop')



sock2 = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
sock2.bind((udp_ip,12346))

