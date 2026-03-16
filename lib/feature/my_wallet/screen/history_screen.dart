// import 'package:fetchtrue/core/costants/dimension.dart';
// import 'package:fetchtrue/core/widgets/custom_appbar.dart';
// import 'package:fetchtrue/core/widgets/custom_container.dart';
// import 'package:flutter/material.dart';
//
// class TransactionHistoryScreen extends StatelessWidget {
//   final List<Map<String, String>> transactions = List.generate(6, (index) {
//     return {
//       "transactionId": "1234****",
//       "date": "20 Aug 25",
//       "time": "6.00 PM",
//       "bankName": "HDFC",
//       "accountNo": "62623171****",
//       "amount": "₹ 1,500",
//       "status": "Successful",
//     };
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: 'History', showBackButton: true,),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "View Transaction History",
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//             10.height,
//             Expanded(
//               child: ListView.builder(
//                 itemCount: transactions.length,
//                 itemBuilder: (context, index) {
//                   final tx = transactions[index];
//                   return TransactionCard(
//                     transactionId: tx["transactionId"]!,
//                     date: tx["date"]!,
//                     time: tx["time"]!,
//                     bankName: tx["bankName"]!,
//                     accountNo: tx["accountNo"]!,
//                     amount: tx["amount"]!,
//                     status: tx["status"]!,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TransactionCard extends StatelessWidget {
//   final String transactionId;
//   final String date;
//   final String time;
//   final String bankName;
//   final String accountNo;
//   final String amount;
//   final String status;
//
//   const TransactionCard({
//     super.key,
//     required this.transactionId,
//     required this.date,
//     required this.time,
//     required this.bankName,
//     required this.accountNo,
//     required this.amount,
//     required this.status,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomContainer(
//       color: Colors.white,
//       margin: EdgeInsets.only(bottom: 10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.arrow_upward, color: Colors.green),
//             SizedBox(width: 8),
//             Text(
//               "Transfer to bank account",
//               style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),
//             ),
//             Spacer(),
//             Text(
//               "+ $amount",
//               style: TextStyle(fontSize: 16,
//                   fontWeight: FontWeight.bold, color: Colors.green),
//             ),
//           ],
//         ),
//         10.height,
//         Row(
//           children: [
//             Expanded(
//               child: Column(
//                 children: [
//                   InfoRow(title: "Transaction ID", value: transactionId),
//                   InfoRow(title: "Bank Name", value: bankName),
//                   InfoRow(title: "Account No", value: accountNo),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 children: [
//                   InfoRow(title: "Date", value: date),
//                   InfoRow(title: "Time", value: time),
//                   InfoRow(title: "Pay Status", value: status),
//                 ],
//               ),
//             )
//           ],
//         )
//       ],
//     ),
//     );
//   }
// }
//
// class InfoRow extends StatelessWidget {
//   final String title;
//   final String value;
//
//   const InfoRow({super.key, required this.title, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Text(
//               "$title :",
//               style: TextStyle(fontSize: 12,color: Colors.grey[700]),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500, color: Colors.grey),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/earning_history/earning_history_bloc.dart';
import '../bloc/earning_history/earning_history_event.dart';
import '../bloc/earning_history/earning_history_state.dart';
import '../repository/earning_history_repository.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final String userId;
  const TransactionHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EarningHistoryBloc(EarningHistoryRepository())
        ..add(FetchEarningHistoryEvent(userId: userId)),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'History', showBackButton: true),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "View Transaction History",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              10.height,
              Expanded(
                child: BlocBuilder<EarningHistoryBloc, EarningHistoryState>(
                  builder: (context, state) {
                    if (state is EarningHistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is EarningHistoryLoaded) {
                      if (state.earningHistory.isEmpty) {
                        return const Center(child: Text("No transactions found."));
                      }
                      return ListView.builder(
                        itemCount: state.earningHistory.length,
                        itemBuilder: (context, index) {
                          final tx = state.earningHistory[index];
                          return TransactionCard(
                            transactionId: tx.transactionId.isEmpty
                                ? "N/A"
                                : tx.transactionId,
                            date: tx.date,
                            time: tx.time,
                            bankName: tx.bankName ?? "N/A",
                            accountNo: tx.accountNumber ?? "N/A",
                            amount: "₹ ${tx.amount.toStringAsFixed(2)}",
                            status: tx.status.capitalize(),
                            type: tx.type,
                          );
                        },
                      );
                    } else if (state is EarningHistoryError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String transactionId;
  final String date;
  final String time;
  final String bankName;
  final String accountNo;
  final String amount;
  final String status;
  final String type;

  const TransactionCard({
    super.key,
    required this.transactionId,
    required this.date,
    required this.time,
    required this.bankName,
    required this.accountNo,
    required this.amount,
    required this.status,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = type.toLowerCase() == "credit";
    final icon = isCredit ? Icons.arrow_downward : Icons.arrow_upward;
    final color = isCredit ? Colors.red : Colors.green;

    return CustomContainer(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                isCredit ? "Received from bank" : "Transfer to bank account",
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              const Spacer(),
              Text(
                "${isCredit ? '-' : '+'} $amount",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          10.height,
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    InfoRow(title: "Transaction ID", value: transactionId),
                    InfoRow(title: "Bank Name", value: bankName),
                    InfoRow(title: "Account No", value: accountNo),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    InfoRow(title: "Date", value: date),
                    InfoRow(title: "Time", value: time),
                    InfoRow(title: "Pay Status", value: status),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              "$title :",
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringCasing on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}
