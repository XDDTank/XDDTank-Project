// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.Compose.ComposeModel

package store.view.Compose
{
    import flash.events.EventDispatcher;
    import road7th.data.DictionaryData;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.events.IEventDispatcher;

    public class ComposeModel extends EventDispatcher 
    {

        private var _composeItemInfoDic:DictionaryData;
        private var _composeBigDic:DictionaryData = new DictionaryData();
        private var _composeMiddelDic:DictionaryData = new DictionaryData();
        private var _composeSmallDic:DictionaryData = new DictionaryData();
        private var _currentItem:ItemTemplateInfo;
        private var _seletectedPage:DictionaryData = new DictionaryData();
        private var _composeSuccess:Boolean;

        public function ComposeModel(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public function get composeItemInfoDic():DictionaryData
        {
            return (this._composeItemInfoDic);
        }

        public function set composeItemInfoDic(_arg_1:DictionaryData):void
        {
            this._composeItemInfoDic = _arg_1;
        }

        public function get composeBigDic():DictionaryData
        {
            return (this._composeBigDic);
        }

        public function set composeBigDic(_arg_1:DictionaryData):void
        {
            this._composeBigDic = _arg_1;
        }

        public function get composeMiddelDic():DictionaryData
        {
            return (this._composeMiddelDic);
        }

        public function set composeMiddelDic(_arg_1:DictionaryData):void
        {
            this._composeMiddelDic = _arg_1;
        }

        public function get composeSmallDic():DictionaryData
        {
            return (this._composeSmallDic);
        }

        public function set composeSmallDic(_arg_1:DictionaryData):void
        {
            this._composeSmallDic = _arg_1;
        }

        public function set currentItem(_arg_1:ItemTemplateInfo):void
        {
            this._currentItem = _arg_1;
            dispatchEvent(new ComposeEvents(ComposeEvents.CLICK_SMALL_ITEM));
        }

        public function get currentItem():ItemTemplateInfo
        {
            return (this._currentItem);
        }

        public function saveSelectedPageSmall(_arg_1:int, _arg_2:int):void
        {
            var _local_3:Array;
            for each (_local_3 in this._seletectedPage)
            {
                _local_3[1] = -2;
            };
            this.getseletectedPageByBigType(_arg_1)[1] = _arg_2;
            this.getseletectedPageByBigType(_arg_1)[2] = this.getSeletedPageMiddle(_arg_1);
        }

        public function getSelectedPageSmallToMiddle(_arg_1:int):int
        {
            return (this.getseletectedPageByBigType(_arg_1)[2]);
        }

        public function getSelectedPageSmall(_arg_1:int):int
        {
            return (this.getseletectedPageByBigType(_arg_1)[1]);
        }

        public function saveSeletedPageMiddle(_arg_1:int, _arg_2:int):void
        {
            this.getseletectedPageByBigType(_arg_1)[0] = _arg_2;
        }

        public function getSeletedPageMiddle(_arg_1:int):int
        {
            return (this.getseletectedPageByBigType(_arg_1)[0]);
        }

        private function getseletectedPageByBigType(_arg_1:int):Array
        {
            var _local_2:Array;
            if ((!(this._seletectedPage[this._composeBigDic[_arg_1]])))
            {
                _local_2 = new Array();
                _local_2[0] = -1;
                _local_2[1] = -1;
                _local_2[2] = -1;
                this._seletectedPage[this._composeBigDic[_arg_1]] = _local_2;
            };
            return (this._seletectedPage[this._composeBigDic[_arg_1]]);
        }

        public function resetseletectedPage():void
        {
            this._seletectedPage = new DictionaryData();
        }

        public function get composeSuccess():Boolean
        {
            return (this._composeSuccess);
        }

        public function set composeSuccess(_arg_1:Boolean):void
        {
            this._composeSuccess = _arg_1;
        }


    }
}//package store.view.Compose

