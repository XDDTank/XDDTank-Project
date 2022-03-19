// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.transportSence.TransportInfoContent

package consortion.transportSence
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;

    public class TransportInfoContent extends Sprite implements Disposeable 
    {

        private var _content:FilterFrameText;
        private var _isMyInfo:Boolean;

        public function TransportInfoContent(_arg_1:String, _arg_2:String, _arg_3:int, _arg_4:int)
        {
            this._content = ComponentFactory.Instance.creatComponentByStylename("TransportInfoPanel.infoContentTextStyle");
            this._content.htmlText = LanguageMgr.GetTranslation("consortion.ConsortionTransport.hijackInfoContent.txt", _arg_1, _arg_2, _arg_3, _arg_4);
            addChild(this._content);
        }

        override public function get width():Number
        {
            return (this._content.textWidth);
        }

        override public function get height():Number
        {
            return (this._content.textHeight + 4);
        }

        public function dispose():void
        {
        }

        public function dispose2():void
        {
            while (this.numChildren > 0)
            {
                this.removeChildAt(0);
            };
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            this._content = null;
        }

        public function get isMyInfo():Boolean
        {
            return (this._isMyInfo);
        }

        public function set isMyInfo(_arg_1:Boolean):void
        {
            this._isMyInfo = _arg_1;
        }


    }
}//package consortion.transportSence

