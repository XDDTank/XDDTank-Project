// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.PetSkillEliementAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;

    public class PetSkillEliementAnalyzer extends DataAnalyzer 
    {

        public var buffTemplateInfo:Dictionary = new Dictionary();

        public function PetSkillEliementAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:XML;
            var _local_5:BuffTemplateInfo;
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Item;
                for each (_local_4 in _local_3)
                {
                    _local_5 = new BuffTemplateInfo();
                    _local_5.ID = _local_4.@ID;
                    _local_5.Name = _local_4.@Name;
                    _local_5.Description = _local_4.@Description;
                    _local_5.EffectPic = _local_4.@EffectPic;
                    this.buffTemplateInfo[_local_5.ID] = _local_5;
                };
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }


    }
}//package ddt.data.analyze

class BuffTemplateInfo 
{

    public var ID:int;
    public var Name:String;
    public var Description:String;
    public var EffectPic:String;


}


