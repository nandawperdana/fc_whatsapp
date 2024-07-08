//
//  ProfleView.swift
//  WhatsappClone
//
//  Created by nandawperdana on 08/07/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileUIViewModel
    
    var body: some View {
        VStack() {
            Spacer().frame(height: 24)
            
            if let avatar = viewModel.avatar {
                Image(uiImage: avatar)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
            }
            
            Text(viewModel.userName)
                .font(.system(size: 20))
                .padding(.top, 12)
            
            Text(viewModel.status)
                .font(.system(size: 12))
                .padding(.top, 2)
                .foregroundColor(.gray)
            
            Spacer().frame(height: 24)
            
            Button(action: {
                viewModel.navigateToChatVC { chatVC in
                    viewModel.navigate(vc: chatVC)
                }
            }) {
                HStack {
                    Image(systemName: "bubble.fill")
                        .foregroundColor(.green)
                        .padding(.horizontal, 16)
                        .background(
                            Circle().fill(Color.gray).frame(width: 32, height: 32, alignment: .center)
                        )
                    Text("Send a message").foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .padding(.trailing, 16)
                }
                .frame(height: 48)
                .background(Color.white)
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchAvatarImage()
        }
        .background(Color(UIColor.systemGray5))
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ProfileView(viewModel: ProfileUIViewModel(user: User.currentUser!))
}

class ProfileUIViewModel: ObservableObject {
    @Published var user: User
    @Published var avatar: UIImage? = UIImage(systemName: "person.fill")
    
    var onNavigate: ((UIViewController) -> Void)?
    
    var userName: String {
        return user.username
    }
    var status: String {
        return user.status
    }
    
    init(user: User) {
        self.user = user
    }
    
    func fetchAvatarImage() {
        if !user.avatar.isEmpty {
            FirebaseStorageHelper.downloadImage(url: user.avatar) { image in
                self.avatar = image?.circleMasked
            }
        }
    }
    
    func navigateToChatVC(completion: @escaping (ChatViewController) -> Void) {
        guard let currentUser = User.currentUser else { return }
        
        let chatRoomId = StartChatHelper.shared.startChat(user1: currentUser, user2: user)
        let chatVC = ChatViewController(chatId: chatRoomId, recipientId: user.id, recipientName: user.username, recipientAvatar: user.avatar)
        
        completion(chatVC)
    }
    
    func navigate(vc: UIViewController) {
        onNavigate?(vc)
    }
}
