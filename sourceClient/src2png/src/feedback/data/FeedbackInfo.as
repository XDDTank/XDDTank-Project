// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.data.FeedbackInfo

package feedback.data
{
    public class FeedbackInfo 
    {

        private var _userID:int;
        private var _userName:String;
        private var _userNickName:String;
        private var _questionTitle:String;
        private var _questionContent:String;
        private var _occurrenceDate:String;
        private var _questionType:int;
        private var _goodsGetMethod:String;
        private var _goodsGetDate:String;
        private var _chargeOrderId:String;
        private var _chargeMethod:String;
        private var _chargeMoneys:Number;
        private var _activityIsError:Boolean = true;
        private var _activityName:String;
        private var _reportUserName:String;
        private var _reportUrl:String;
        private var _userFullName:String;
        private var _userPhone:String;
        private var _complaintsTitle:String;
        private var _complaintsSource:String;
        private var _appraisalGrade:String;
        private var _appraisalContent:String;


        public function get question_title():String
        {
            return (this._questionTitle);
        }

        public function set question_title(_arg_1:String):void
        {
            this._questionTitle = _arg_1;
        }

        public function get question_content():String
        {
            return (this._questionContent);
        }

        public function set question_content(_arg_1:String):void
        {
            this._questionContent = _arg_1;
        }

        public function get occurrence_date():String
        {
            return (this._occurrenceDate);
        }

        public function set occurrence_date(_arg_1:String):void
        {
            this._occurrenceDate = _arg_1;
        }

        public function get question_type():int
        {
            return (this._questionType);
        }

        public function set question_type(_arg_1:int):void
        {
            this._questionType = _arg_1;
        }

        public function get goods_get_method():String
        {
            return (this._goodsGetMethod);
        }

        public function set goods_get_method(_arg_1:String):void
        {
            this._goodsGetMethod = _arg_1;
        }

        public function get goods_get_date():String
        {
            return (this._goodsGetDate);
        }

        public function set goods_get_date(_arg_1:String):void
        {
            this._goodsGetDate = _arg_1;
        }

        public function get charge_order_id():String
        {
            return (this._chargeOrderId);
        }

        public function set charge_order_id(_arg_1:String):void
        {
            this._chargeOrderId = _arg_1;
        }

        public function get charge_method():String
        {
            return (this._chargeMethod);
        }

        public function set charge_method(_arg_1:String):void
        {
            this._chargeMethod = _arg_1;
        }

        public function get charge_moneys():Number
        {
            return (this._chargeMoneys);
        }

        public function set charge_moneys(_arg_1:Number):void
        {
            this._chargeMoneys = _arg_1;
        }

        public function get activity_is_error():Boolean
        {
            return (this._activityIsError);
        }

        public function set activity_is_error(_arg_1:Boolean):void
        {
            this._activityIsError = _arg_1;
        }

        public function get activity_name():String
        {
            return (this._activityName);
        }

        public function set activity_name(_arg_1:String):void
        {
            this._activityName = _arg_1;
        }

        public function get report_user_name():String
        {
            return (this._reportUserName);
        }

        public function set report_user_name(_arg_1:String):void
        {
            this._reportUserName = _arg_1;
        }

        public function get report_url():String
        {
            return (this._reportUrl);
        }

        public function set report_url(_arg_1:String):void
        {
            this._reportUrl = _arg_1;
        }

        public function get user_full_name():String
        {
            return (this._userFullName);
        }

        public function set user_full_name(_arg_1:String):void
        {
            this._userFullName = _arg_1;
        }

        public function get user_phone():String
        {
            return (this._userPhone);
        }

        public function set user_phone(_arg_1:String):void
        {
            this._userPhone = _arg_1;
        }

        public function get complaints_title():String
        {
            return (this._complaintsTitle);
        }

        public function set complaints_title(_arg_1:String):void
        {
            this._complaintsTitle = _arg_1;
        }

        public function get complaints_source():String
        {
            return (this._complaintsSource);
        }

        public function set complaints_source(_arg_1:String):void
        {
            this._complaintsSource = _arg_1;
        }

        public function get appraisal_grade():String
        {
            return (this._appraisalGrade);
        }

        public function set appraisal_grade(_arg_1:String):void
        {
            this._appraisalGrade = _arg_1;
        }

        public function get appraisal_content():String
        {
            return (this._appraisalContent);
        }

        public function set appraisal_content(_arg_1:String):void
        {
            this._appraisalContent = _arg_1;
        }

        public function get user_id():int
        {
            return (this._userID);
        }

        public function set user_id(_arg_1:int):void
        {
            this._userID = _arg_1;
        }

        public function get user_name():String
        {
            return (this._userName);
        }

        public function set user_name(_arg_1:String):void
        {
            this._userName = _arg_1;
        }

        public function get user_nick_name():String
        {
            return (this._userNickName);
        }

        public function set user_nick_name(_arg_1:String):void
        {
            this._userNickName = _arg_1;
        }


    }
}//package feedback.data

