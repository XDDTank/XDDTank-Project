// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.data.ActivityRewardInfo

package activity.data
{
    public class ActivityRewardInfo 
    {

        public var GiftbagId:String;
        public var TemplateId:String;
        public var Count:int;
        public var IsBind:Boolean;
        public var OccupationOrSex:int;
        public var RewardType:int;
        public var ValidDate:int;
        public var Property:String;
        public var Remain1:String;


        public function getProperty():Array
        {
            return (this.Property.split(","));
        }


    }
}//package activity.data

