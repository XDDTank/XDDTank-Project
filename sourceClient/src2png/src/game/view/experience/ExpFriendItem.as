// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.experience.ExpFriendItem

package game.view.experience
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import game.view.playerThumbnail.HeadFigure;
    import com.pickgliss.ui.text.FilterFrameText;
    import game.model.Player;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;

    public class ExpFriendItem extends Sprite implements Disposeable 
    {

        private var _head:HeadFigure;
        private var _nameTxt:FilterFrameText;
        private var _expTxt:FilterFrameText;
        private var _exploitTxt:FilterFrameText;

        public function ExpFriendItem(_arg_1:Player)
        {
            this.init(_arg_1);
        }

        private function init(_arg_1:Player):void
        {
            var _local_2:int;
            this._head = new HeadFigure(27, 27, _arg_1);
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("experience.LeftViewNameTxt");
            this._expTxt = ComponentFactory.Instance.creatComponentByStylename("experience.LeftViewScoreTxt");
            this._exploitTxt = ComponentFactory.Instance.creatComponentByStylename("experience.LeftViewScoreTxt");
            PositionUtils.setPos(this._exploitTxt, "experience.FriendItemTxtPos_3");
            PositionUtils.setPos(this._head, "experience.FriendItemHeadPos");
            this._nameTxt.text = _arg_1.playerInfo.NickName;
            if (this._nameTxt.textWidth > 130)
            {
                _local_2 = this._nameTxt.getCharIndexAtPoint(130, 5);
                this._nameTxt.text = (this._nameTxt.text.substring(0, _local_2) + "...");
            };
            this._expTxt.text = ("+" + _arg_1.expObj.gainGP);
            if (_arg_1.expObj.gainOffer)
            {
                if (_arg_1.GainOffer < 0)
                {
                    this._exploitTxt.text = _arg_1.GainOffer.toString();
                }
                else
                {
                    this._exploitTxt.text = ("+" + _arg_1.GainOffer.toString());
                };
            }
            else
            {
                this._exploitTxt.text = "+0";
            };
            addChild(this._head);
            addChild(this._nameTxt);
            addChild(this._expTxt);
        }

        public function dispose():void
        {
            if (this._head)
            {
                this._head.dispose();
                this._head = null;
            };
            if (this._nameTxt)
            {
                this._nameTxt.dispose();
                this._nameTxt = null;
            };
            if (this._expTxt)
            {
                this._expTxt.dispose();
                this._expTxt = null;
            };
            if (this._exploitTxt)
            {
                this._exploitTxt.dispose();
                this._exploitTxt = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.experience

