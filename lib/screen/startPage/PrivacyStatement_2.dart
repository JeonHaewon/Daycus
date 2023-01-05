import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrivacyStatement extends StatelessWidget {
  PrivacyStatement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('개인정보 취급방침',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //SvgPicture.asset('assets/image/file1.svg' , fit: BoxFit.fill, ),

            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 0),
              child: Column(
                children: [

                  Container(
                    width: 400.w,
                    height: 85.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          padding: EdgeInsets.fromLTRB(25.w, 15.h, 25.w, 0),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("< Happy Circuit > ('https://www.daycus.com'이하 'Daycus')은(는) 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.",style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h,),




                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
                    child: Column(
                      children: [
                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제1조(개인정보의 처리 목적)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Text("< Happy Circuit >('https://www.daycus.com'이하 'Daycus')은(는) 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.",
                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),

                        SizedBox(height: 10.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("1. 홈페이지 회원가입 및 관리",style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              Text("회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 각종 고지·통지, 고충처리 목적으로 개인정보를 처리합니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("2. 민원사무 처리",style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              Text("민원인의 신원 확인, 민원사항 확인, 사실조사를 위한 연락·통지, 처리결과 통보 목적으로 개인정보를 처리합니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("3. 재화 또는 서비스 제공",style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              Text("서비스 제공, 콘텐츠 제공, 맞춤서비스 제공, 본인인증을 목적으로 개인정보를 처리합니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),

                        SizedBox(height: 6.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("4. 마케팅 및 광고에의 활용",style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              Text("신규 서비스(제품) 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공 , 서비스의 유효성 확인, 접속빈도 파악 또는 회원의 서비스 이용에 대한 통계 등을 목적으로 개인정보를 처리합니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),




                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제2조(개인정보의 처리 및 보유 기간)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("① < Happy Circuit >은(는) 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),

                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.",style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),

                              SizedBox(height: 2.h,),
                              Text(" 1.<홈페이지 회원가입 및 관리>",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • <홈페이지 회원가입 및 관리>와 관련한 개인정보는 수집.이용에 관한 동의일로부터<3년>까지 위 이용목적을 위하여 보유.이용됩니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 보유근거 : 이용약관",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 예외사유 : 회원탈퇴 및 사용자가 원하는 경우",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),

                              SizedBox(height: 2.h,),
                              Text(" 2.<민원사무 처리>",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • <민원사무 처리>와 관련한 개인정보는 수집.이용에 관한 동의일로부터<3년>까지 위 이용목적을 위하여 보유.이용됩니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 보유근거 : 이용약관",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 관련법령 : 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 예외사유 : 회원탈퇴 및 사용자가 원하는 경우",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),

                              SizedBox(height: 2.h,),
                              Text(" 3.<재화 또는 서비스 제공>",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • <재화 또는 서비스 제공>와 관련한 개인정보는 수집.이용에 관한 동의일로부터<3년>까지 위 이용목적을 위하여 보유.이용됩니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 보유근거 : 이용약관",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 예외사유 : 회원탈퇴 및 사용자가 원하는 경우",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),

                              SizedBox(height: 2.h,),
                              Text(" 4.<마케팅 및 광고에의 활용>",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • <마케팅 및 광고에의 활용>와 관련한 개인정보는 수집.이용에 관한 동의일로부터<3년>까지 위 이용목적을 위하여 보유.이용됩니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 보유근거 : 이용약관",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 예외사유 : 회원탈퇴 및 사용자가 원하는 경우",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),



                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제3조(처리하는 개인정보의 항목)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("① < Happy Circuit >은(는) 다음의 개인정보 항목을 처리하고 있습니다.",style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),

                              SizedBox(height: 2.h,),
                              Text(" 1.<홈페이지 회원가입 및 관리>",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 필수항목 : 이메일, 비밀번호 질문과 답, 비밀번호, 로그인ID, 서비스 이용 기록, 접속 로그",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 선택항목 : 성별, 생년월일",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),



                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제4조(개인정보의 파기절차 및 파기방법)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("① < Happy Circuit > 은(는) 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("② 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),

                              SizedBox(height: 2.h,),
                              Text(" 1. 법령 근거 :   ",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),

                              SizedBox(height: 2.h,),
                              Text(" 2. 보존하는 개인정보 항목 : 계좌정보, 거래날짜",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),

                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("③ 개인정보 파기의 절차 및 방법은 다음과 같습니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              SizedBox(height: 2.h,),
                              Text(" 1. 파기절차 : < Happy Circuit > 은(는) 파기 사유가 발생한 개인정보를 선정하고, < Happy Circuit > 의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.  ",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),

                              SizedBox(height: 2.h,),
                              Text(" 2. 파기방법 : 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),




                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제5조(정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("① 정보주체는 Happy Circuit에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("② 제1항에 따른 권리 행사는Happy Circuit에 대해 「개인정보 보호법」 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 Happy Circuit은(는) 이에 대해 지체 없이 조치하겠습니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다.이 경우 “개인정보 처리 방법에 관한 고시(제2020-7호)” 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("④ 개인정보 열람 및 처리정지 요구는 「개인정보 보호법」 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("⑥ Happy Circuit은(는) 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),






                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제6조(개인정보의 안전성 확보조치에 관한 사항)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Text("< Happy Circuit >은(는) 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.",
                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                        SizedBox(height: 10.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("1. 정기적인 자체 감사 실시",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              SizedBox(height: 2.h,),
                              Text(" 개인정보 취급 관련 안정성 확보를 위해 정기적(분기 1회)으로 자체 감사를 실시하고 있습니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("2. 개인정보 취급 직원의 최소화 및 교육",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              SizedBox(height: 2.h,),
                              Text(" 개인정보를 취급하는 직원을 지정하고 담당자에 한정시켜 최소화 하여 개인정보를 관리하는 대책을 시행하고 있습니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("3. 내부관리계획의 수립 및 시행",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              SizedBox(height: 2.h,),
                              Text(" 개인정보의 안전한 처리를 위하여 내부관리계획을 수립하고 시행하고 있습니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("4. 개인정보의 암호화",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              SizedBox(height: 2.h,),
                              Text(" 이용자의 개인정보는 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("5. 비인가자에 대한 출입 통제",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              SizedBox(height: 2.h,),
                              Text(" 개인정보를 보관하고 있는 물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),




                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제7조(개인정보를 자동으로 수집하는 장치의 설치·운영 및 그 거부에 관한 사항)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Text("< Happy Circuit > 은(는) 정보주체의 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용하지 않습니다.",
                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                        SizedBox(height: 10.h,),



                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제8조(행태정보의 수집·이용·제공 및 거부 등에 관한 사항)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Text("행태정보의 수집·이용·제공 및 거부등에 관한 사항 : Daycus는 온라인 맞춤형 광고 등을 위한 행태정보를 수집·이용·제공하지 않습니다.",
                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                        SizedBox(height: 10.h,),



                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제9조(추가적인 이용·제공 판단기준)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Text("< Happy Circuit > 은(는) ｢개인정보 보호법｣ 제15조제3항 및 제17조제4항에 따라 ｢개인정보 보호법 시행령｣ 제14조의2에 따른 사항을 고려하여 정보주체의 동의 없이 개인정보를 추가적으로 이용·제공할 수 있습니다. 이에 따라 < Happy Circuit > 가(이) 정보주체의 동의 없이 추가적인 이용·제공을 하기 위해서 다음과 같은 사항을 고려하였습니다.",
                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                        SizedBox(height: 3.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("  ▶ 개인정보를 추가적으로 이용·제공하려는 목적이 당초 수집 목적과 관련성이 있는지 여부",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              Text("  ▶ 개인정보를 수집한 정황 또는 처리 관행에 비추어 볼 때 추가적인 이용·제공에 대한 예측 가능성이 있는지 여부",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              Text("  ▶ 개인정보의 추가적인 이용·제공이 정보주체의 이익을 부당하게 침해하는지 여부",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              Text("  ▶ 가명처리 또는 암호화 등 안전성 확보에 필요한 조치를 하였는지 여부",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              Text("  ※ 추가적인 이용·제공 시 고려사항에 대한 판단기준은 사업자/단체 스스로 자율적으로 판단하여 작성·공개함",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),






                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제10조(가명정보를 처리하는 경우 가명정보 처리에 관한 사항)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Text("< Happy Circuit > 은(는) 다음과 같은 목적으로 가명정보를 처리하고 있습니다.",
                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                        SizedBox(height: 3.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("  ▶ 가명정보의 처리 목적",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              Text("    - AI 개발 및 학습데이터 확보",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              SizedBox(height: 2.h,),

                              Text("  ▶ 가명정보의 처리 및 보유기간",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              Text("    - 가명정보 처리 및 통계 데이터 확보 시까지",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              SizedBox(height: 2.h,),

                              Text("  ▶ 가명정보의 제3자 제공에 관한 사항(해당되는 경우에만 작성)",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              Text("    - 제 3자 제공을 하지 않습니다",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              SizedBox(height: 2.h,),

                              Text("  ▶ 가명정보 처리의 위탁에 관한 사항(해당되는 경우에만 작성)",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              Text("    - 가명정보 처리를 위탁하지 않습니다",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              SizedBox(height: 2.h,),

                              Text("  ▶ 가명처리하는 개인정보의 항목",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              Text("    - 성별, 나이, 어플 내 미션인증 데이터",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              SizedBox(height: 2.h,),

                              Text("  ▶ 법 제28조의4(가명정보에 대한 안전조치 의무 등)에 따른 가명정보의 안전성 확보조치에 관한 사항",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              Text("    - 개인정보 암호화를 통한 안정성 확보",
                                  style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ),
                              SizedBox(height: 2.h,),

                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),







                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제11조 (개인정보 보호책임자에 관한 사항)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("① Happy Circuit 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              SizedBox(height: 2.h,),
                              Text("   ▶ 개인정보 보호책임자",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 성명 :석시환",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 직책 :CCO",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 직급 :CCO",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 연락처 :01055759316, happycircuit0301@gmail.com, 0504-498-2204",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              SizedBox(height: 3.h,),
                              Text("  ※ 개인정보 보호 담당부서로 연결됩니다.",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              SizedBox(height: 3.h,),
                              Text("   ▶ 개인정보 보호 담당부서",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 부서명 :기획-영업",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 담당자 :석시환",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 연락처 :01055759316, happycircuit0301@gmail.com, 0504-498-2204",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("② 정보주체께서는 Happy Circuit 의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. Happy Circuit 은(는) 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),

                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),





                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제12조(개인정보의 열람청구를 접수·처리하는 부서)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Text("정보주체는 ｢개인정보 보호법｣ 제35조에 따른 개인정보의 열람 청구를 아래의 부서에 할 수 있습니다. < Happy Circuit >은(는) 정보주체의 개인정보 열람청구가 신속하게 처리되도록 노력하겠습니다.",
                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                        SizedBox(height: 3.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("   ▶ 개인정보 열람청구 접수·처리 부서",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 부서명 : 기획-영업",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 담당자 : 석시환",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                              Text("   • 연락처 :01055759316, happycircuit0301@gmail.com, 0504-498-2204",
                                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),





                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제13조(정보주체의 권익침해에 대한 구제방법)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Text("정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.",
                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                        SizedBox(height: 10.h,),

                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              SizedBox(height: 2.h,),
                              Text("2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              SizedBox(height: 2.h,),
                              Text("3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                              SizedBox(height: 2.h,),
                              Text("4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h,),
                        Text("「개인정보보호법」제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.",
                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean',) ),
                        SizedBox(height: 3.h,),
                        Text("※ 행정심판에 대해 자세한 사항은 중앙행정심판위원회(www.simpan.go.kr) 홈페이지를 참고하시기 바랍니다.",
                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean',) ),
                        SizedBox(height: 10.h,),





                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),
                        SizedBox(height: 6.h,),
                        Text("제14조(개인정보 처리방침 변경)",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue) ),
                        SizedBox(height: 5.h,),
                        Container(
                          width: 400.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("① 이 개인정보처리방침은 2022년 12월 30부터 적용됩니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,) ),

                            ],
                          ),
                        ),
                        SizedBox(height: 20.h,),


                      ],
                    ),
                  ),





                ],
              ),

            ),
















          ],
        ),
      ),
    );
  }
}
