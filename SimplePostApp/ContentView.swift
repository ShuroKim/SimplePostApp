//
//  ContentView.swift
//  SimplePostApp
//
//  Created by Shuraw on 3/26/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var postVM = PostViewModel()
    
    var body: some View {
        NavigationView {
            TabView {
                Forum()
                    .tabItem {
                        Image(systemName: "bubble.right")
                    }
                Text("두번째 탭")
                    .tabItem {
                        Image(systemName: "house")
                    }
            }
            .navigationTitle("Scrum 스터디 방")
        }
        .environmentObject(postVM)
    }
}

struct Forum: View {
    @EnvironmentObject var postVM: PostViewModel
//    @State private var list: [Post] = Post.list
    
    @State private var isShowAddView: Bool = false
    @State private var newPost = Post()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($postVM.list) { $post in
                    NavigationLink {
                        PostDetail(post: $post)
                    }label: {
                        PostRow(post: post)
                    }
                    .tint(.primary)
                }
            }
        }
        .refreshable {
            
        }
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            Button {
                isShowAddView = true
            }label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .padding()
                    .background {
                        Circle().fill(.white).shadow(radius: 4)
                    }
            }
            .padding()
        }
        .sheet(isPresented: $isShowAddView, onDismiss: {
//            isShowAddView = false
            newPost = Post()
        }, content: {
            NavigationView {
                PostAdd(editPost: $newPost)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("취소") {
                                isShowAddView = false
//                                newPost = Post()
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("게시") {
                                postVM.addPost(text: newPost.content)
                                isShowAddView = false
//                                newPost = Post()
                            }
                        }
                    }
            }
        })
    }
}

class PostViewModel: ObservableObject {
    @Published var list: [Post] = Post.list
    
    func addPost(text: String) {
        let newPost = Post(userName: "유저 이름", content: text)
        list.insert(newPost, at: 0)
    }
}

struct PostAdd: View {
    @FocusState private var focused: Bool
    
    @Binding var editPost: Post
    
//    @Environment(\.dismiss) private var dismiss
    
//    @State private var text: String
    
//    @EnvironmentObject var postVM: PostViewModel // body load 시점에 나옴
//        
//    init(post: Post? = nil) {   // 공식문서에 이렇게 쓰지말래요 초기값지정
//        _text = State(wrappedValue: post?.content ?? "")
//    }
//    
    var body: some View {
        VStack(content: {
            TextField("포스트 입력바랍니다.", text: $editPost.content)
                .font(.title)
                .padding()
                .padding(.top)
                .focused($focused)
                .onAppear {
                    focused = true
                }
            Spacer()
        })
        .navigationTitle("포스트 게시")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct PostDetail: View {
    @State private var isShowEdit: Bool = false

    @Binding var post: Post
    @State private var editPost = Post(userName: "유저 이름", content: "")
    
    var body: some View {
        VStack(spacing: 20, content: {
            Text(post.userName)
            Text(post.content)
                .font(.largeTitle)
            Button {
                editPost = post
                isShowEdit = true
            }label: {
                Image(systemName: "pencil")
                Text("수정")
            }
            .fullScreenCover(isPresented: $isShowEdit, content: {
                NavigationView {
                    PostAdd(editPost: $editPost)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("취소") {
                                    isShowEdit = false
                                }
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("게시") {
                                    post = editPost
                                    isShowEdit = false
                                }
                            }
                        }
                }
            })
            
//            .sheet(item: post, content: {
//                NavigationView {
//                    PostAdd(editPost: $editPost)
//                        .toolbar {
//                            ToolbarItem(placement: .navigationBarLeading) {
//                                Button("취소") {
//                                    isShowEdit = false
//                                }
//                            }
//                            
//                            ToolbarItem(placement: .navigationBarTrailing) {
//                                Button("게시") {
//                                    post = editPost
//                                    isShowEdit = false
//                                }
//                            }
//                        }
//                }
//            })
//            .sheet(isPresented: $isShowEdit, content: {
//                PostAdd()
//            })
        })
    }
}

struct PostRow: View {
    let post: Post
    let colors: [Color] = [
        Color.orange, Color.green, Color.purple, Color.pink, Color.blue, Color.yellow, Color.brown, Color.cyan, Color.mint, Color.indigo, Color.teal
    ]
    var body: some View {
        HStack {
            Circle()
                .fill(colors.randomElement() ?? .black)
                .frame(width: 30)
            VStack(alignment: .leading, content: {
                Text(post.userName)
                Text(post.content)
                    .font(.title)
            })
            Spacer()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder()
        }
        .padding()
    }
}

struct Post: Identifiable {
    let id = UUID().uuidString
    let userName: String
    var content: String
    
    init(userName: String = "유저 디폴트", content: String = "") {
        self.userName = userName
        self.content = content
    }
}

extension Post {
    static var list: [Post] = [
        Post(userName: "김대현1", content: "내용1"),
        Post(userName: "김대현2", content: "내용2"),
        Post(userName: "김대현3", content: "내용31"),
        Post(userName: "김대현4", content: "내용41"),
        Post(userName: "김대현5", content: "내용165"),
        Post(userName: "김대현6", content: "내용17"),
        Post(userName: "김대현7", content: "내용18"),
        Post(userName: "김대현8", content: "내용19")

    ]
    
}

#Preview {
//    NavigationView {
//        Forum()
//    }
//    PostAdd { post in
//
//    }
//    PostDetail(post:  Post(userName: "김대현8", content: "내용19"))
//    PostRow(post: Post(userName: "김대현8", content: "내용19"))
    ContentView()
}
