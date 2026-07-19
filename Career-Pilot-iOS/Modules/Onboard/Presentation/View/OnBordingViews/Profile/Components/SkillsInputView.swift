//
//  SkillsInputView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 19/07/2026.
//

import SwiftUI
struct SkillsInputView: View {
    @Binding var selectedSkills: [String]
    @State private var newSkillText: String = ""
    
    let suggestedSkills: [String] = ["React" , "Flutter" , "Mobile Development" , "Python" , "Git" , "System design" , "Docker"]
    private var skills: Binding<[String]> {
        Binding(
            get: { selectedSkills },
            set: { selectedSkills = $0 }
        )
    }
    
    private var visibleSuggestions: [String] {
        suggestedSkills.filter { !skills.wrappedValue.contains($0) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FlowLayout(spacing: 8) {
                ForEach(skills.wrappedValue, id: \.self) { skill in
                    SelectedSkillChip(text: skill) {
                        print("You cliked remove skill \(skill)")
                        skills.wrappedValue.removeAll { $0 == skill }
                    }
                }
                
                TextField("e.g.React,Python...", text: $newSkillText)
                    .font(.subheadline)
                    .foregroundColor(.gray400)
                    .frame(minWidth: 80) .onChange(of: newSkillText) { newValue in
                        if newValue.contains(",") {
                            newSkillText = newValue.replacingOccurrences(of: ",", with: "")
                            addSkill()
                        }
                    }
                    .onSubmit {
                        addSkill()
                    }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: Radius.r16)
                    .stroke(Color.gray200, lineWidth: 1)
            )
            
            if !visibleSuggestions.isEmpty {
                Text("SUGGESTED FOR ENGINEER")
                    .font(.caption.bold())
                    .foregroundColor(.gray400)
                
                FlowLayout(spacing: 8) {
                    ForEach(visibleSuggestions, id: \.self) { skill in
                        SuggestedSkillChip(text: skill) {
                            print("I clicked to be added \(skill)")
                            skills.wrappedValue.append(skill)
                        }
                    }
                }
            }
        }
    }
    
    private func addSkill() {
        let trimmed = newSkillText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        let alreadyExists = skills.wrappedValue.contains {
            $0.caseInsensitiveCompare(trimmed) == .orderedSame
        }
        guard !alreadyExists else {
            newSkillText = ""
            return
        }
        
        skills.wrappedValue.append(trimmed)
        newSkillText = ""
    }
    
}

//struct SkillsInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        SkillsInputView(selectedSkills: ["Flutter"], suggestedSkills: ["Mobile development" , "Python" , "Docker" , "Git" , "System design" ] )
//    }
//}
