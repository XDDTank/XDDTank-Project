// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.HelpPrompt

package store
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class HelpPrompt extends Component 
    {

        private var _bg9Scale:Scale9CornerImage;
        public var bg9ScalseStyle:String;
        public var contentStyle:String;
        private var contentArr:Array;


        override protected function onProppertiesUpdate():void
        {
            var _local_3:DisplayObject;
            super.onProppertiesUpdate();
            this._bg9Scale = ComponentFactory.Instance.creat(this.bg9ScalseStyle);
            addChild(this._bg9Scale);
            var _local_1:Array = this.contentStyle.split(/,/g);
            this.contentArr = new Array();
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                _local_3 = ComponentFactory.Instance.creat(_local_1[_local_2]);
                addChild(_local_3);
                this.contentArr.push(_local_3);
                _local_2++;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._bg9Scale)
            {
                ObjectUtils.disposeObject(this._bg9Scale);
            };
            this._bg9Scale = null;
            var _local_1:int;
            while (_local_1 < this.contentArr.length)
            {
                ObjectUtils.disposeObject(this.contentArr[_local_1]);
                this.contentArr[_local_1] = null;
                _local_1++;
            };
            this.contentArr = null;
        }


    }
}//package store

