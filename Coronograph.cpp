#include <iostream>
#include <list>
#include<fstream>
#include<vector>

using namespace std;

class Graph {
    int N;
    list<int> len;
    list<int> *adj;
    list<int> path;
    int *parent;
    int length;
 public:
    void DFS(int v, bool visited[], int temp);
    Graph(int N);
    void del();
    void Print();
    void Find_Path();
    void add_Edge(int V, int W);
    bool Has_Cycle();
    void Remove();
    void Print_adj();
    void Find_Len(bool visited[], int node);
};
Graph::Graph(int N){
    this->N = N;
    adj = new list<int>[N];
    parent = new int[N];
}
void Graph::Find_Len(bool visited[], int node){
    visited[node] = true;
    list<int>::iterator i; 
    for (i = adj[node].begin(); i != adj[node].end(); i++){                                                               
        if (!visited[*i]){                     //If a node is not visited then continue
            length += 1;                       //length is for counting the lenght 
            Find_Len(visited, *i);             //of the trees                    
        }
    }
}
void Graph::add_Edge(int V, int W){
    adj[V].push_back(W);
    adj[W].push_back(V);
}
void Graph::DFS(int node, bool visited[], int temp){
    visited[node] = true;
    list<int>::iterator i; 
    for (i = adj[node].begin(); i != adj[node].end(); i++){                                                               
        if (!visited[*i]){                     //If a node is not visited then continue
            parent[*i] = node;                 //from that node,, with parent = previous node
             DFS(*i, visited, node);           //of the trees, for the last output                      
        }
        else if (*i!= temp){                  //If a node is visited and not equal with parent
            path.push_back(*i);               //then we have Cylce, and add this node to path      
        }
    }
}
void Graph::Find_Path(){            //Find all the nodes that make the Cycle happen 
    list<int>::iterator End;        //and save them in list "path"
    list<int>::iterator First;
    First = path.begin();           //In the beginning path only has 2 nodes
    First++;
    End = First;
    First--;
    while (parent[*End] != *First ){
        path.push_back(parent[*End]);     //Start from last node and add its parent = ( parent[node] )
        End++;                            //in path. Then repeat for node = parent[node] 
    }                                     //until it reaches the first node
}
void Graph::Remove(){               //This function removes edges from nodes in path
    list<int>::iterator j;          //so that, all nodes are separated from each other
    list<int>::iterator i;          //and there is no cycle
    j = path.begin();
    i = path.begin();
    j++;
    adj[*i].remove(*j);
    adj[*j].remove(*i);
    for (i = j; i != path.end(); i++){
        adj[*i].remove(parent[*i]);
        adj[parent[*i]].remove(*i);
    }
}
bool Graph::Has_Cycle(){          
    if (path.empty())              //If there are no nodes in path, then there is no cycle
        return false; 
    else
    return true;  
}
void Graph::Print(){
        bool *visited = new bool[N];
        for (int i = 0; i < N; i++) visited[i] = false;

        cout << "CORONA " << path.size() << endl;

        list<int>::iterator j;

        for (j = path.begin(); j != path.end(); j++){
            length = 1;               //length measures the length of each tree        
            Find_Len(visited, *j);    //it must be length = 1, to measure correctly
            len.push_back(length);    //add each lenth to list "len"
        }
        len.sort();    
        list<int>::iterator last;
        last = len.end();
        last--;
        for (j = len.begin(); j != last; j++) cout << *j << " ";
        cout << *last << endl;
}
int main (int argc, char **argv){   
    int T,M,N,node1,node2;
    ifstream inFile;
    inFile.open(argv[1]);
    inFile >> T;
    for (int i =0; i < T; i++){
        inFile >> N;
        inFile >> M;   
        bool connected = true;
        Graph G(N+1);
        bool *visited = new bool[N];
        for (int i = 0; i < N; i++) visited[i] = false;  
        for(int j = 0; j < M; j++){
            inFile >> node1;
            inFile >> node2;
            G.add_Edge(node1, node2);
        }
        if(N == M){
            G.DFS(1, visited, 0);
            visited[0] = true;
            visited[1] = true;
            for(int t=2; t<N; t++){
                if(visited[t] == false) {
                    connected = false;
                    break;
                }
            }
            if (G.Has_Cycle() and connected){
                G.Find_Path();
                G.Remove();
                G.Print();
            }
            else cout << "NO CORONA" << endl; 
        }
        else cout << "NO CORONA" << endl;
        
    }
    return 0;
}