// ignore_for_file: avoid_print

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trichy_iccc_grievance/Controller/grievance_controller.dart';
import 'package:trichy_iccc_grievance/Model/auth/api_url.dart';
import 'package:trichy_iccc_grievance/Model/complaint_model.dart';
import 'package:trichy_iccc_grievance/Model/complaint_type.dart';
import 'package:trichy_iccc_grievance/Model/department_type.dart';
import 'package:trichy_iccc_grievance/Model/street_model.dart';
import 'package:trichy_iccc_grievance/Model/ward_model.dart';
import 'package:trichy_iccc_grievance/Model/zone_model.dart';
import 'package:trichy_iccc_grievance/View/widgets/buttons.dart';
import 'package:trichy_iccc_grievance/View/widgets/dropdown_widget.dart';
import 'package:trichy_iccc_grievance/color.dart';
import 'package:http/http.dart' as http;

class GrievanceDetail extends StatefulWidget {
  const GrievanceDetail({super.key});

  @override
  State<GrievanceDetail> createState() => _GrievanceDetailState();
}

class _GrievanceDetailState extends State<GrievanceDetail> {
  final GrievanceController grievanceController = Get.put(GrievanceController());
  String? _selectedComplainttype;
  String? _selectedDepartment;
  String? selectComplaint;
  String? selectedZone;
  String? selectedWard;
  String? selectedStreet;
  List<String> complaintTypes = [];
  List<String> departmentTypes = [];
  List<String> complaint = [];
  List<String> zones =[];
  List<String> wards =[];
  List<String> streets = [];
  final TextEditingController pincode = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
   List<String> filteredComplaints = [];
   List<String> filteredzone = [];

  // Future<void> _pickFiles() async {
  //   try {
  //     final pickedFiles = await _picker.pickMultiImage();

  //     if (_selectedFiles.length + pickedFiles.length <= 5) {
  //       setState(() {
  //         _selectedFiles.addAll(pickedFiles);
  //       });
  //     } else {
  //        Fluttertoast.showToast(
  //     msg: 'You can only select up to 5 images in total',
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.green,
  //     textColor: Colors.white,
  //     fontSize: 15.0,
  //   ); 
  //     }
  //       } catch (e) {
  //     print('Error picking files: $e');
  //   }
  // }
  Future<void> _pickFiles() async {
  try {
    final pickedFiles = await _picker.pickMultiImage();

    for (var file in pickedFiles) {
      final fileBytes = await file.readAsBytes();
      final fileSizeInKB = fileBytes.lengthInBytes / 1024;
      

      if (fileSizeInKB <= 400) {
        if (_selectedFiles.length < 5) {
          setState(() {
            _selectedFiles.add(file);
          });
        } else {
          Fluttertoast.showToast(
            msg: 'You can only select up to 5 images in total',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 15.0,
          );
          break;
        }
      } else {
        Fluttertoast.showToast(
          msg: 'File ${file.name} exceeds 400KB and was not added',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0,
        );
      }
    }
    } catch (e) {
    print('Error picking files: $e');
  }
}


  Future<void> _uploadFiles(String grievanceId) async {
    if (_selectedFiles.isEmpty) return;

    final uri = Uri.parse(ApiUrl.grievattach); 

    final request = http.MultipartRequest('POST', uri)
      ..fields['grievance_id'] = grievanceId 
      ..fields['created_by_user'] = 'public_user'; 

    for (var file in _selectedFiles) {
      final multipartFile = await http.MultipartFile.fromPath('files', file.path);
      request.files.add(multipartFile);
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
      
      } else {
        print('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      
      
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }
  

 void fetchGrievanceData() async {
    try {
      List<ComplaintType> complaintType1 = await grievanceController.getAllComplaintTypes();
      List<String> complaintTypeList = complaintType1.map((type) => type.complaintType).toList();
      List<Department> department1 = await grievanceController.getAllDepartment();
      List<String> departmentList = department1.map((type) => type.deptname).toList();
      List<ComplaintModel> complaint1 = await grievanceController.getAllComplaint();
      List<String> complaintList = complaint1.map((type) => type.complainttypetitle).toList();
      List<ZoneModel> zoneType = await grievanceController.getZone();
      List<String> zonelist = zoneType.map((type) => type.zonename).toList();
      List<WardModel> wardType = await grievanceController.getWard();
      List<String> wardlist = wardType.map((type) => type.wardname).toList();
      List<StreetModel> streetType = await grievanceController.getStreet();
      List<String> streetList = streetType.map((type) => type.streetname).toList();

      setState(() {
        complaintTypes = complaintTypeList;
        departmentTypes = departmentList;
        complaint = complaintList;
        zones = zonelist;
        wards = wardlist;
        streets = streetList; 
               
      });
    } catch (e) {
      // Handle error
      debugPrint('Error fetching complaint types: $e');
    }
  }
  

  void fetchComplaintsByDepartment(String selectedDepartment) async {
    try {
      List<ComplaintModel> allComplaints = await grievanceController.getAllComplaint();

      // Filter complaints based on the selected department
      List<ComplaintModel> departmentComplaints = allComplaints.where((complaint) {
        return complaint.deptname == selectedDepartment;
      }).toList();

      setState(() {
        filteredComplaints = departmentComplaints.map((complaint) => complaint.complainttypetitle).toList();
         selectComplaint = null;  // Reset the selected complaint type
      });
    } catch (e) {
      debugPrint('Error fetching complaints: $e');
    }
  }


  void onDepartmentSelected(String department) {
    setState(() {
      _selectedDepartment = department;
    });

    fetchComplaintsByDepartment(department);
  }
 
// void fetchZone(String selectedDepartment) async {
//   try {
//     // Fetch all wards
//     List<WardModel> wardType = await grievanceController.getWard();

//     // Filter wards based on the selected zone (department)
//     List<WardModel> departmentComplai = wardType.where((zone) {
//       return zone.zonename == selectedDepartment;
//     }).toList();

//     setState(() {
//       // Map the filtered wards to their names
//       filteredzone = departmentComplai.map((ward) => ward.wardname).toList();
//       selectedZone = null;  // Reset the selected complaint type
//     });
//   } catch (e) {
//     debugPrint('Error fetching wards: $e');
//   }
// }

// void onDepartmentSelec(String department) {
//   setState(() {
//     selectedZone = department;
//   });

//   // Fetch wards based on the selected zone (department)
//   fetchZone(department);
// }\
  List<String> filteredWards = [];
  List<String> filteredStreets = [];
  void fetchWardsByZone(String selectedZone) async {
    try {
      List<WardModel> allWards = await grievanceController.getWard();
      List<WardModel> zoneWards = allWards.where((ward) {
        return ward.zonename == selectedZone;
      }).toList();

      setState(() {
        filteredWards = zoneWards.map((ward) => ward.wardname).toList();
        selectedWard = null;
      });
    } catch (e) {
      debugPrint('Error fetching wards by zone: $e');
    }
  }

  void fetchStreetsByWard(String selectedWard) async {
    try {
      List<StreetModel> allStreets = await grievanceController.getStreet();
      List<StreetModel> wardStreets = allStreets.where((street) {
        return street.wardname == selectedWard;
      }).toList();

      setState(() {
        filteredStreets = wardStreets.map((street) => street.streetname).toList();
        selectedStreet = null;
      });
    } catch (e) {
      debugPrint('Error fetching streets by ward: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    fetchGrievanceData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.all(8),
              child: Row(children: [
                IconButton(onPressed: (){
            Navigator.pop(context);
           },style: IconButton.styleFrom(
             backgroundColor: const Color.fromARGB(255, 215, 229, 241),
             padding: const EdgeInsets.only(left: 9)
           ), icon: const Icon(Icons.arrow_back_ios,)),
           const SizedBox(width: 3,),
           const Text("Grievance Details",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),),
              ],),
              ),
              const SizedBox(height: 10,),
               complaintTypes.isEmpty || departmentTypes.isEmpty || complaint.isEmpty || zones.isEmpty || wards.isEmpty || streets.isEmpty
          ? const Center(child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Please wait, loading...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),)
          :Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownWidget(
                      labelText: 'Complaint Type',
                      value: _selectedComplainttype,
                        onChanged: (String? newValue) {
                setState(() {
                  _selectedComplainttype = newValue;
                });
              },
                items: complaintTypes,
              ),
               const SizedBox(height: 16),
              //  DropdownWidget(
              //   labelText: departmentTypes.isEmpty ? 'No data ' : 'Department', 
              //   value: _selectedDepartment,
              //   onChanged: (String? value){
              //     setState(() {
              //       _selectedDepartment = value;
              //     });
              //   }, 
              //   items: departmentTypes),
              DropdownButtonFormField<String>(
                 decoration:  InputDecoration(
                labelText:'Department',
                 hintStyle: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: const BorderSide(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 0.1),
                                                width: 2.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: const BorderSide(
                                                color:
                                                  Color.fromRGBO(0, 0, 0, 0.1),
                                               width: 2.0)),
              ),
                value: _selectedDepartment,
                
                items: departmentTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(), // Correctly mapping Strings to DropdownMenuItems
                onChanged: (newValue) {
                  onDepartmentSelected(newValue!);
                },
              ),
                 const SizedBox(height: 16),
                // DropdownWidget(
                //   labelText:complaint.isEmpty ? "No complaint" : 'Complaint', 
                //   onChanged: (String? newValue){
                //     setState(() {
                //       selectComplaint = newValue;
                      
                //     });
                //   }, 
                //   items: complaint),
                  DropdownButtonFormField<String>(
                     decoration:  InputDecoration(
                labelText:'Complaint',
                 hintStyle: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: const BorderSide(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 0.1),
                                                width: 2.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: const BorderSide(
                                                color:
                                                  Color.fromRGBO(0, 0, 0, 0.1),
                                               width: 2.0)),
              ),
                value: selectComplaint,
                items: filteredComplaints.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(), 
                onChanged: (newValue) {
                  setState(() {
                    selectComplaint = newValue!;
                  });
                },
              ),
                 const SizedBox(height: 16),
              //        DropdownButtonFormField<String>(
              //    decoration:  InputDecoration(
              //   labelText:zones.isEmpty ? 'No data ' : 'Zone',
              //    hintStyle: const TextStyle(
              //                               color: Colors.black87,
              //                               fontSize: 14,
              //                               fontWeight: FontWeight.normal),
              //                           enabledBorder: OutlineInputBorder(
              //                               borderRadius:
              //                                   BorderRadius.circular(15.0),
              //                               borderSide: const BorderSide(
              //                                   color:
              //                                       Color.fromRGBO(0, 0, 0, 0.1),
              //                                   width: 2.0)),
              //                           focusedBorder: OutlineInputBorder(
              //                               borderRadius:
              //                                   BorderRadius.circular(15.0),
              //                               borderSide: const BorderSide(
              //                                   color:
              //                                     Color.fromRGBO(0, 0, 0, 0.1),
              //                                  width: 2.0)),
              // ),
              //   value: selectedZone,
                
              //   items: zones.map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(), // Correctly mapping Strings to DropdownMenuItems
              //   onChanged: (newValue) {
              //     onDepartmentSelec(newValue!);
              //   },
              // ),
              //   const SizedBox(height: 16),
                // DropdownWidget(
                //   labelText:complaint.isEmpty ? "No complaint" : 'Complaint', 
                //   onChanged: (String? newValue){
                //     setState(() {
                //       selectComplaint = newValue;
                      
                //     });
                //   }, 
                //   items: complaint),
//                DropdownButtonFormField<String>(
//                  decoration:  InputDecoration(
//                 labelText:zones.isEmpty ? 'No data ' : 'Ward',
//                  hintStyle: const TextStyle(
//                                             color: Colors.black87,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.normal),
//                                         enabledBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(15.0),
//                                             borderSide: const BorderSide(
//                                                 color:
//                                                     Color.fromRGBO(0, 0, 0, 0.1),
//                                                 width: 2.0)),
//                                         focusedBorder: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(15.0),
//                                             borderSide: const BorderSide(
//                                                 color:
//                                                   Color.fromRGBO(0, 0, 0, 0.1),
//                                                width: 2.0)),
//               ),
//   value: selectedWard,
//   onChanged: (String? newValue) {
//     setState(() {
//       selectedZone = newValue;
//     });
//   },
//   items: filteredzone.map<DropdownMenuItem<String>>((String value) {
//     return DropdownMenuItem<String>(
//       value: value,
//       child: Text(value),
//     );
//   }).toList(),
// ),




                            DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Zone',
                        hintStyle: const TextStyle(
                            color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                      ),
                      value: selectedZone,
                      items: zones.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedZone = newValue;
                        });
                        fetchWardsByZone(newValue!);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Ward',
                        hintStyle: const TextStyle(
                            color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                      ),
                      value: selectedWard,
                      items: filteredWards.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedWard = newValue;
                        });
                        fetchStreetsByWard(newValue!);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Street',
                        hintStyle: const TextStyle(
                            color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                      ),
                      value: selectedStreet,
                      items: filteredStreets.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          value,
          maxLines: 2,
         
        ),
      ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedStreet = newValue;
                        });
                      },
                    ),

                // DropdownWidget(labelText: zones.isEmpty ? 'No zone' :'Zone', 
                // onChanged: (String? newValue){
                //   setState(() {
                //     selectedZone = newValue;
                //   });
                // }, 
                // items: zones),
              // const SizedBox(height: 16),
              //  DropdownWidget(
              //   labelText: wards.isEmpty ? 'No ward' :'Ward',
              //    onChanged: (String? newValue){
              //     setState(() {
              //       selectedWard = newValue;
              //     });
              //    }, items: wards),
            
                 //const SizedBox(height: 16),
                  // DropdownWidget(labelText:streets.isEmpty ? 'No street' :'Street', 
                  // onChanged: (String? newvalue){
                  //   setState(() {
                  //     selectedStreet = newvalue;
                  //   });
                  // }, items: streets),
               
                 const SizedBox(height: 16),
                  TextFormField(
              controller: pincode,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Pincode',
                 hintStyle: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: const BorderSide(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 0.1),
                                                width: 2.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: const BorderSide(
                                                color:
                                                  Color.fromRGBO(0, 0, 0, 0.1),
                                                width: 2.0)),
              ),
               validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a pincode';
    } else if (value.length != 6) {
      return 'Pincode must be 6 digits';
    }
    return null; // Return null if validation passes
  },
            ),
              const SizedBox(height: 16),
              TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                 hintStyle: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: const BorderSide(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 0.1),
                                                width: 2.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: const BorderSide(
                                                color:
                                                  Color.fromRGBO(0, 0, 0, 0.1),
                                                width: 2.0)),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16.0),
           GestureDetector(
                onTap: _pickFiles,
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: const [5, 5],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(4),
                  child: Container(
                    height: 100,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 30),
                          SizedBox(width: 10),
                          Text('Upload Files (Up to 5 Files)', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    leading: const Icon(Icons.file_present),
                    title: Text(_selectedFiles[index].name),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeFile(index),
                    ),
                  );
                },
              ),
          Center(child: CustomFillButton(buttontext: "Submit", buttoncolor: maincolor, onPressed: () async {
             if (_selectedComplainttype == null || 
            _selectedDepartment == null || 
            selectedZone == null || 
            selectedWard == null || 
            selectedStreet == null || 
            pincode.text.isEmpty || 
            pincode.text.length != 6 ||  
            selectComplaint == null || 
            descriptionController.text.isEmpty) {
          
          Fluttertoast.showToast(
            msg: 'Please enter all required data and ensure the pincode is 6 digits',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 15.0,
          );
          return;
                }
            
            List<ComplaintModel> complaint1 = await grievanceController.getAllComplaint();
              // Initialize priority variable
                String priority = "";
                // Iterate over the complaint list to find the matching complaint type
                for (var type in complaint1) {
          if (type.complainttypetitle == selectComplaint) {
            priority = type.priority; // Assign the found priority
            break; // Exit the loop once the match is found
          }
            
                }   
          
                
           String? grievanceId = await grievanceController.grievancePost(
               context,
              _selectedComplainttype ?? "", 
              _selectedDepartment ?? "", 
              selectedZone ?? "", 
              selectedWard ?? "", 
              selectedStreet ?? "",
              pincode.text,
              selectComplaint ?? "", 
              descriptionController.text,
             priority,
              ); 
              if (grievanceId != null && _selectedFiles.isNotEmpty) {
          // Upload files using the grievance ID
          await _uploadFiles(grievanceId);
                }
                  }, minimumSize: const Size(301, 54), buttontextsize: 20)),
          
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
