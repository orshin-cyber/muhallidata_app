import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_html_to_pdf_plus/flutter_html_to_pdf_plus.dart';
import 'package:intl/intl.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:path_provider/path_provider.dart';

class DataCouponReceipt extends StatefulWidget {
  Map data;
  DataCouponReceipt({required this.data});

  @override
  _DataCouponReceiptState createState() => _DataCouponReceiptState();
}

class _DataCouponReceiptState extends State<DataCouponReceipt> {
  bool token = false;

  late String generatedPdfFilePath;

  String htnldata() {
    print(
        "https://muhallidata.com/static/ogbam/images/${widget.data['net_name']}.jpg");
    String text = "";
    for (int x = 0; x < widget.data['data_pins'].length; x++) {
      text += """
     <td>
                
    <p> <span style="font-weight: bolder; margin-left:10px; font-size:15px">DATA CARD</span><span style="font-weight: bolder;font-size:15px; margin-right:10px;  float:right">${widget.data['plan_network']}</span>
    <br>
    <br>  <img src="https://upload.wikimedia.org/wikipedia/fr/thumb/e/e9/Mtn-logo-svg.svg/2560px-Mtn-logo-svg.svg.png">

                 <div class="content" style="padding-left: 10px;margin-top:-19px;">
                     <center> <p><b>${widget.data["name_on_card"]}</b></p></center>
                     <br>
                    <span><b>PIN:</b></span>&nbsp;&nbsp;<span style="font-size:11px"><b> ${widget.data["data_pins"][x]['fields']["pin"]}</b></span><br>
                    <span><b>S/N:</b></span>&nbsp;&nbsp;<span><b> ${widget.data["data_pins"][x]['fields']["serial"]}</b></span><br>
                    <span><b>Date:</b></span>&nbsp;&nbsp;<span><b>${DateFormat('yyyy-MM-dd – kk:mm a').format(DateTime.parse(widget.data['create_date']))} </b></span><br>
                     <span style="font-size:14px;"> <b> Dail ${widget.data["data_pins"][x]['fields']["load_code"]} to Load</b></span>               
                </div>

                <div class="bottom">


                 <center>

                           <span style="font-size:14px;"><b>Check Bal:</b></span>&nbsp;&nbsp;<span style="font-size:14px;"><b> *461*4# or *131*4# or *556# </b></span><br>
                                           
                          <p style="text-align: center;"><b></b></p>
                                 

                    </center>


                </div>

                </td>

               ${(x != widget.data['data_pins'].length - 1 && x + 1 == 4 || x + 1 == 8 || x + 1 == 16 || x + 1 == 20 || x + 1 == 24 || x + 1 == 28 || x + 1 == 32 || x + 1 == 36 || x + 1 == 40) ? " </tr> <tr>" : ""}


            """;
    }
    ;

    return text;
  }

  Future<void> generateExampleDocument() async {
    var htmlContent = """
   <!DOCTYPE html>
    <html>
      <head>
      
<style>
.table, tr, td {
  border: 1px solid black;
  border-style: dashed;
  padding:0px;

}


td{
    font-size:10px;
}

.amt{
    float:right;
    font-weight: bolder;
}

.content{
    padding-right:30px;
}
img{
   float:right;
   height: 35px;
   width: 35px;
}

.bottom{
    clear:both ;
}
</style>


      </head>
      <body>
     
         <table class=' w3-table-responsive' id="pins">


            <tr>
                ${htnldata()}

            </tr>

        </table>
     
       
      </body>
    </html>
    """;

    Random random = new Random();
    int randomNumber = random.nextInt(10000);
    var appDocDir = await getApplicationDocumentsDirectory();
    var targetPath = appDocDir.path;
    var targetFileName = "DataCouponReceipt$randomNumber";

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      content: htmlContent,
      configuration: PrintPdfConfiguration(
          targetDirectory: targetPath,
          targetName: targetFileName,
          printOrientation: PrintOrientation.Portrait,
          printSize: PrintSize.A4),
    );
    generatedPdfFilePath = generatedPdfFile.path;
    final params = SaveFileDialogParams(sourceFilePath: generatedPdfFilePath);
    final filePath = await FlutterFileDialog.saveFile(params: params);
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("DataCoupon Receipt",
            style: TextStyle(color: Colors.white, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Reference",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${widget.data['id']}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                        ]),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Plan",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${widget.data['plan_network']}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                        ]),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Amount",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "N${widget.data['amount']}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                        ]),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Previous Balance",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "N${widget.data['previous_balance']}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                        ]),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "New Balance",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "N${widget.data['after_balance']}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                        ]),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Quantity",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${widget.data['quantity']}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                        ]),
                    SizedBox(height: 10),
                    Divider(),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Text(
                    //         "Status",
                    //         style: TextStyle(
                    //             fontSize: 17, fontWeight: FontWeight.w400),
                    //       ),
                    //       Text(
                    //         "${widget.data['Status']}",
                    //         style: TextStyle(
                    //             fontSize: 17, fontWeight: FontWeight.w400),
                    //       ),
                    //     ]),
                    // SizedBox(height: 10),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Date",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${DateFormat('yyyy-MM-dd – kk:mm a').format(DateTime.parse(widget.data['create_date']))}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                        ]),
                    SizedBox(height: 10),
                    Divider(),
                  ]),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/home", (route) => false);
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromRGBO(25, 118, 210, 1),
                              const Color.fromRGBO(25, 118, 210, 1),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Back'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      generateExampleDocument();
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromRGBO(25, 118, 210, 1),
                              const Color.fromRGBO(25, 118, 210, 1),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'DOWNLOAD DATA PIN'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
