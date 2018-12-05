def main():
	with open("all_strokes.txt", 'a') as dest_file:
		for i in range(1,16):
			with open(str(i)+'.txt','r') as src_file:
				dest_file.write('\n#' + str(i) + '\n')
				dest_file.write(src_file.read())



if __name__ == '__main__':
	main()