/*
박치국 작성
2017-06-01
*/


import Foundation


struct Student {
	let name: String
	var Grade: Character
	let Average: Double
}//Struct of Students information

extension Student{
	//initialize Students info
	init?(json: [String : Any]) {
		let name = json["name"] as! String
		let gradeJSON = json["grade"] as! [String: Int]
		var sum : Double = 0.0
		for (_, grade) in gradeJSON{
			sum = sum + Double(grade)
		}
	
		self.name = name
		
		//to fix floating point
		let numberOfPlaces = 2.0
		let multiplier = pow(10.0, numberOfPlaces)
		let num = sum / Double(gradeJSON.count)
		let rounded = round(num * multiplier) / multiplier
		
		self.Average = rounded
		
		self.Grade = " "
		if self.Average >= 90 {
			self.Grade = "A"
		}
		else if self.Average < 90 && self.Average >= 80 {
			self.Grade = "B"
		}
		else if self.Average < 80 && self.Average >= 70 {
			self.Grade = "C"
		}
		else if self.Average < 70 && self.Average >= 60 {
			self.Grade = "D"
		}
		else{
			self.Grade = "F"
		}
	}
}


func getHomeDirectory() -> URL {
	let paths = FileManager.default.homeDirectoryForCurrentUser
	return paths
}
private func readJson() {
	do {
		if let file = URL(string: String(describing: getHomeDirectory()) + "students.json") {
			let data = try Data(contentsOf: file)
			let json = try JSONSerialization.jsonObject(with: data, options: []) //make JSON
			if json is [String: Any] {
				print("JSON is Dictionary")
			} else if let object = json as? [Any] {
				//if JSON is valid
				var student : [Student] = []
				let Count = object.count
				var sum: Double = 0
				for index in 0..<Count{
					let temp: Student = Student(json: object[index] as! [String : Any] )!
					student.append(temp)
					sum = sum + student[index].Average
				}
				let output = getHomeDirectory().appendingPathComponent("result.txt")
				var outputdata: String //String Data for Write to File
				outputdata = "성적결과표\n\n"
				let numberOfPlaces = 2.0
				let multiplier = pow(10.0, numberOfPlaces)
				let num = sum / Double(Count)
				let rounded = round(num * multiplier) / multiplier
				outputdata.append("전체 평균 : " + String(rounded) + "\n\n개인별 학점\n")
				func order(s1:Student, s2:Student) -> Bool{
					if s1.name > s1.name{
						return true
					}
					else{
						return false
					}
				}
				student.sort{ $0.name.compare($1.name, options: .numeric) == .orderedAscending} //sorting with name
				var graduate: [String] = []
				for index in 0..<student.count{
					let padded = student[index].name.padding(toLength: 11, withPad: " ", startingAt: 0)
					//to fix length of string
					outputdata.append(padded + ": " + String(student[index].Grade) + "\n")
					if student[index].Average >= 70.0 {
						graduate.append(student[index].name)
					}
				}
				outputdata.append("\n수료생\n")
				for index in 0..<graduate.count - 1 {
					outputdata.append(graduate[index] + ", ")
				}
				outputdata.append(graduate.last!)
				do{
					try outputdata.write(to: output, atomically: true, encoding: String.Encoding.utf8)
				}catch{
					print("File Write Error")
				}
			
			} else {
				print("JSON is invalid")
			}
		} else {
			print("no file")
		}
	} catch {
		print(error.localizedDescription)
	}
}
readJson()
