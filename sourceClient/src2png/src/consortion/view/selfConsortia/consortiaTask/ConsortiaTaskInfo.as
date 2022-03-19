// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.consortiaTask.ConsortiaTaskInfo

package consortion.view.selfConsortia.consortiaTask
{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class ConsortiaTaskInfo 
    {

        public var itemList:Vector.<Object>;
        public var exp:int;
        public var offer:int;
        public var riches:int;
        public var buffID:int;
        public var beginTime:Date;
        public var time:int;
        public var contribution:int;
        private var sortKey:Array = [3, 4, 1, 5, 2];

        public function ConsortiaTaskInfo()
        {
            this.itemList = new Vector.<Object>();
        }

        public function addItemData(_arg_1:int, _arg_2:String, _arg_3:int=0, _arg_4:Number=0, _arg_5:int=0, _arg_6:int=0):void
        {
            var _local_7:Object = new Object();
            _local_7["id"] = _arg_1;
            _local_7["taskType"] = _arg_3;
            _local_7["content"] = _arg_2;
            _local_7["currenValue"] = _arg_4;
            _local_7["targetValue"] = _arg_5;
            _local_7["finishValue"] = _arg_6;
            this.itemList.push(_local_7);
        }

        public function sortItem():void
        {
            var _local_2:int;
            var _local_3:Object;
            var _local_1:Vector.<Object> = new Vector.<Object>();
            while (_local_2 < this.sortKey.length)
            {
                for each (_local_3 in this.itemList)
                {
                    if (this.sortKey[_local_2] == _local_3["taskType"])
                    {
                        _local_1.push(_local_3);
                    };
                };
                _local_2++;
            };
            this.itemList = _local_1;
        }

        public function updateItemData(_arg_1:int, _arg_2:Number=0, _arg_3:int=0):void
        {
            var _local_4:Object;
            for each (_local_4 in this.itemList)
            {
                if (_local_4["id"] == _arg_1)
                {
                    _local_4["currenValue"] = _arg_2;
                    _local_4["finishValue"] = _arg_3;
                };
            };
        }


    }
}//package consortion.view.selfConsortia.consortiaTask

