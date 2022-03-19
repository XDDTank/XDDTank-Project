// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.UserBoxInfoAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import road7th.data.DictionaryData;
    import flash.utils.Dictionary;
    import ddt.data.box.TimeBoxInfo;
    import ddt.data.box.GradeBoxInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class UserBoxInfoAnalyzer extends DataAnalyzer 
    {

        private var _xml:XML;
        private var _goodsList:XMLList;
        public var timeBoxList:DictionaryData;
        public var gradeBoxList:DictionaryData;
        public var boxTemplateID:Dictionary;

        public function UserBoxInfoAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            this._xml = new XML(_arg_1);
            if (this._xml.@value == "true")
            {
                this.timeBoxList = new DictionaryData();
                this.gradeBoxList = new DictionaryData();
                this.boxTemplateID = new Dictionary();
                this._goodsList = this._xml..Item;
                this.parseShop();
            }
            else
            {
                message = this._xml.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }

        private function parseShop():void
        {
            var _local_2:int;
            var _local_3:TimeBoxInfo;
            var _local_4:GradeBoxInfo;
            var _local_5:TimeBoxInfo;
            var _local_1:int;
            while (_local_1 < this._goodsList.length())
            {
                _local_2 = int(this._goodsList[_local_1].@Type);
                switch (_local_2)
                {
                    case 0:
                        _local_3 = new TimeBoxInfo();
                        ObjectUtils.copyPorpertiesByXML(_local_3, this._goodsList[_local_1]);
                        this.boxTemplateID[_local_3.TemplateID] = _local_3.TemplateID;
                        this.timeBoxList.add(_local_3.ID, _local_3);
                        break;
                    case 1:
                        _local_4 = new GradeBoxInfo();
                        ObjectUtils.copyPorpertiesByXML(_local_4, this._goodsList[_local_1]);
                        this.boxTemplateID[_local_4.TemplateID] = _local_4.TemplateID;
                        this.gradeBoxList.add(_local_4.ID, _local_4);
                        break;
                    case 2:
                        _local_5 = new TimeBoxInfo();
                        ObjectUtils.copyPorpertiesByXML(_local_5, this._goodsList[_local_1]);
                        this.boxTemplateID[_local_5.TemplateID] = _local_5.TemplateID;
                        break;
                };
                _local_1++;
            };
            onAnalyzeComplete();
        }

        private function getXML():XML
        {
            return (<Result value="true" message="Success!">
  <Item ID="1" Type="0" Level="20" Condition="15" TemplateID="1120090"/>
  <Item ID="2" Type="0" Level="20" Condition="40" TemplateID="1120091"/>
  <Item ID="3" Type="0" Level="20" Condition="60" TemplateID="1120092"/>
  <Item ID="4" Type="0" Level="20" Condition="75" TemplateID="1120093"/>
  <Item ID="6" Type="1" Level="4" Condition="1" TemplateID="1120071"/>
  <Item ID="7" Type="1" Level="5" Condition="1" TemplateID="1120072"/>
  <Item ID="8" Type="1" Level="8" Condition="1" TemplateID="1120073"/>
  <Item ID="9" Type="1" Level="10" Condition="1" TemplateID="1120074"/>
  <Item ID="10" Type="1" Level="11" Condition="1" TemplateID="1120075"/>
  <Item ID="11" Type="1" Level="12" Condition="1" TemplateID="1120076"/>
  <Item ID="12" Type="1" Level="15" Condition="1" TemplateID="1120077"/>
  <Item ID="13" Type="1" Level="20" Condition="1" TemplateID="1120078"/>
  <Item ID="14" Type="1" Level="4" Condition="0" TemplateID="1120081"/>
  <Item ID="15" Type="1" Level="5" Condition="0" TemplateID="1120082"/>
  <Item ID="16" Type="1" Level="8" Condition="0" TemplateID="1120083"/>
  <Item ID="17" Type="1" Level="10" Condition="0" TemplateID="1120084"/>
  <Item ID="18" Type="1" Level="11" Condition="0" TemplateID="1120085"/>
  <Item ID="19" Type="1" Level="12" Condition="0" TemplateID="1120086"/>
  <Item ID="20" Type="1" Level="15" Condition="0" TemplateID="1120087"/>
  <Item ID="21" Type="1" Level="20" Condition="0" TemplateID="1120088"/>
  <Item ID="14" Type="2" Level="4" Condition="0" TemplateID="112112"/>
  <Item ID="15" Type="2" Level="5" Condition="0" TemplateID="112113"/>
  <Item ID="16" Type="2" Level="8" Condition="0" TemplateID="112114"/>
  <Item ID="17" Type="2" Level="10" Condition="0" TemplateID="112115"/>
  <Item ID="18" Type="2" Level="11" Condition="0" TemplateID="112116"/>
  <Item ID="19" Type="2" Level="12" Condition="0" TemplateID="112117"/>
  <Item ID="20" Type="2" Level="15" Condition="0" TemplateID="112118"/>
 <Item ID="21" Type="2" Level="20" Condition="0" TemplateID="112119"/>
 <Item ID="21" Type="2" Level="20" Condition="0" TemplateID="112120"/>
</Result>
            );
        }


    }
}//package ddt.data.analyze

