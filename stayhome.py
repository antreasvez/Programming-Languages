import sys
file_name = sys.argv[1]
file = open(file_name, "rt")
chars = [list(x.strip('\n')) for x in file]
N = len(chars)
M = len(chars[0])
def find_one_letter(letter):
    coords = []
    for i in range(N):
        for j in range(M):
            if chars[i][j] == letter:
                coords.append((i,j))
                return coords
def find_multiple_letters(letter):
    coords = []
    for i in range(N):
        for j in range(M):
            if chars[i][j] == letter:
                coords.append((i,j))
    return coords
W = find_one_letter("W")
S = find_one_letter("S")
T = find_one_letter("T")
A = find_multiple_letters("A")
Xes = find_multiple_letters("X")
spread = [[-1 for x in range(M)] for y in range(N)]
parent = [[(-1, -1) for j in range(M)] for i in range(N)]
visited = [[False for x in range(M)] for y in range(N)]
(S1,S2) = S[0]
(T1, T2) = T[0]
(w1, w2) = W[0]
visited[S1][S2] = True
spread[w1][w2] = 0
time = -1
airport = False
tempA = A
path = ""   
for (i0,j0) in Xes:
    spread[i0][j0] = -3
for (i1,j1) in A:
    spread[i1][j1] = -2
def check_moves(x1,x2):
    global airport
    lst = []
    if x1 > 0:
        if spread[x1-1][x2] > -3 and spread[x1-1][x2] < 0:
            if spread[x1-1][x2] == -2:
                airport = True
            lst.append((x1-1,x2))
    if x2 > 0:
        if spread[x1][x2-1] > -3 and spread[x1][x2-1] < 0:
            if spread[x1][x2-1] == -2:
                airport = True
            lst.append((x1,x2-1))
    if x1 < N-1:
        if spread[x1+1][x2] > -3 and spread[x1+1][x2] < 0:
            if spread[x1+1][x2] == -2:
                airport = True
            lst.append((x1+1,x2))
    if x2 < M-1:
        if spread[x1][x2+1] > -3 and spread[x1][x2+1] < 0:
            if spread[x1][x2+1] == -2:
                airport = True
            lst.append((x1,x2+1))
    return lst
def check_moves_sotiri(x1,x2,t):
    lst = []
    if x1 < N-1:
        if (spread[x1+1][x2] != -3 and spread[x1+1][x2] < 0) or spread[x1+1][x2] > t+1:
            if not visited[x1+1][x2]:
                lst.append((x1+1,x2))
    if x2 > 0:
        if (spread[x1][x2-1] != -3 and spread[x1][x2-1] < 0) or spread[x1][x2-1] > t+1:
            if not visited[x1][x2-1]:
                lst.append((x1,x2-1))
    if x2 < M-1:
        if (spread[x1][x2+1] != -3 and spread[x1][x2+1] < 0) or spread[x1][x2+1] > t+1:
            if not visited[x1][x2+1]:
                lst.append((x1,x2+1))
    if x1 > 0:
        if (spread[x1-1][x2] != -3 and spread[x1-1][x2] < 0) or spread[x1-1][x2] > t+1:
            if not visited[x1-1][x2]:
                lst.append((x1-1,x2))
    return lst
while((spread[T1][T2] < 0 or spread[T1][T2] != time) and visited[T1][T2] == False):
    temp2 = []
    temp1 = []
    NewS = []
    time += 1
    if time % 2 == 0:
        for (i,j) in W:
            if airport:
                for (i2,j2) in A:
                    if spread[i2][j2] == -2:
                        for (i,j) in tempA:
                            spread[i][j] = time + 7
                    break
            if time - spread[i][j] == 0:
                temp1 += check_moves(i,j)
                for (x,y) in check_moves(i,j):
                    spread[x][y] = time+2
        W = temp1
    else: 
        if airport:     
            for (i2,j2) in A:
                temp2 += check_moves(i2,j2)
                for (i3,j3) in check_moves(i2,j2):
                    spread[i3][j3] = time + 8
            A = temp2
            
    for (i,j) in S:
        sotiris_spread = check_moves_sotiri(i,j,time)  
        NewS += sotiris_spread
        for (x,y) in sotiris_spread:
            visited[x][y] = True
            parent[x][y] = (i,j)
    S = NewS
def lexicographic_move(i,j):
    (i2,j2) = parent[i][j]
    if i - 1 == i2:
        return "D"
    elif j + 1 == j2:
        return "L"
    elif j - 1 == j2:
        return "R"
    elif i + 1 == i2:
        return "U"
    return ""
if S == []:
    print("IMPOSSIBLE")
else:
    node = T[0]
    (i,j) = node
    for t in range(time+1):
        path = lexicographic_move(i,j) + path
        (i,j) = parent[i][j]
    print(time+1)
    print(path)




