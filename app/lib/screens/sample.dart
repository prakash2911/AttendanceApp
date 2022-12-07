// DropDownField(
// isExpanded: true,
// hint: const Text(
// 'Select category',
// style: TextStyle(
// fontSize: 14,
// fontWeight: FontWeight.bold,
// color: Colors.white,
// ),
// overflow: TextOverflow.ellipsis,
// ),
// items: complaints
//     .map((item) => DropdownMenuItem<String>(
// value: item,
// child: Text(
// item,
// style: const TextStyle(
// fontSize: 14,
// fontWeight: FontWeight.bold,
// color: Colors.white,
// ),
// overflow: TextOverflow.ellipsis,
// ),
// ))
// .toList(),
// value: complaint,
// onChanged: (value) {
// setState(() {
// complaint = value as String;
// });
// },
// icon: const Icon(
// Icons.arrow_forward_ios_outlined,
// ),
// iconSize: 14,
// iconEnabledColor: Colors.white,
// buttonPadding: const EdgeInsets.only(left: 20, right: 20),
// buttonDecoration: BoxDecoration(
// borderRadius: BorderRadius.circular(14),
// border: Border.all(
// color: Colors.black26,
// ),
// color: Colors.grey[800],
// ),
// buttonElevation: 2,
// dropdownDecoration: BoxDecoration(
// borderRadius: BorderRadius.circular(14),
// color: Colors.grey[800],
// ),
// dropdownElevation: 8,
// scrollbarRadius: const Radius.circular(40),
// scrollbarThickness: 6,
// scrollbarAlwaysShow: true,
// // )