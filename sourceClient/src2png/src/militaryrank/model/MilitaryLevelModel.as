// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//militaryrank.model.MilitaryLevelModel

package militaryrank.model
{
    public class MilitaryLevelModel 
    {

        public var Name:String;
        public var MinScore:int;
        public var MaxScore:int;
        public var CurrKey:int;


        public function isThisLevel(_arg_1:int):Boolean
        {
            return ((_arg_1 >= this.MinScore) && (_arg_1 < this.MaxScore));
        }


    }
}//package militaryrank.model

