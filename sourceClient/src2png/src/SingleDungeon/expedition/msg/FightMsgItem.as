// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.expedition.msg.FightMsgItem

package SingleDungeon.expedition.msg
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.view.chat.ChatData;
    import ddt.manager.LanguageMgr;
    import ddt.manager.ItemManager;
    import ddt.view.chat.ChatInputView;
    import ddt.view.chat.ChatFormats;
    import ddt.utils.Helpers;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class FightMsgItem extends Sprite implements Disposeable 
    {

        private var _msg:FilterFrameText;
        private var _info:FightMsgInfo;

        public function FightMsgItem()
        {
            this.initMsg();
        }

        public function set info(_arg_1:FightMsgInfo):void
        {
            this._info = _arg_1;
            this.createMessage();
        }

        private function createMessage():void
        {
            var _local_1:ItemTemplateInfo;
            var _local_2:ChatData;
            var _local_3:String;
            var _local_4:String;
            var _local_5:String;
            var _local_6:String;
            if (this._info.templateID == 1)
            {
                if (this._info.dungeonName)
                {
                    this._msg.htmlText = this._info.dungeonName;
                }
                else
                {
                    this._msg.htmlText = LanguageMgr.GetTranslation("singledungeon.expedition.fightMsg.text1", this._info.times);
                };
            }
            else
            {
                if (this._info.templateID == -1)
                {
                    this._msg.htmlText = LanguageMgr.GetTranslation("singledungeon.expedition.fightMsg.text4");
                }
                else
                {
                    if (this._info.templateID == -2)
                    {
                        this._msg.htmlText = LanguageMgr.GetTranslation("singledungeon.expedition.fightMsg.text5");
                    }
                    else
                    {
                        _local_1 = ItemManager.Instance.getTemplateById(this._info.templateID);
                        _local_2 = new ChatData();
                        _local_2.channel = ChatInputView.SYS_TIP;
                        _local_3 = LanguageMgr.GetTranslation("singledungeon.expedition.fightMsg.text2");
                        _local_4 = "";
                        _local_5 = "";
                        _local_6 = "";
                        if (this._info.templateID == -100)
                        {
                            _local_4 = ((" " + this._info.count) + " ");
                            _local_5 = this._info.name;
                            _local_6 = "";
                        }
                        else
                        {
                            _local_4 = ((" " + this._info.count) + LanguageMgr.GetTranslation("singledungeon.expedition.fightMsg.text3"));
                            _local_5 = (("<font color='#4ea6ff'>" + ChatFormats.creatBracketsTag((("[" + this._info.name) + "]"), ChatFormats.CLICK_USERNAME)) + "</font>");
                            _local_6 = ".";
                        };
                        _local_2.htmlMessage = (((_local_3 + _local_4) + _local_5) + _local_6);
                        this.setChats(_local_2);
                    };
                };
            };
        }

        private function setChats(_arg_1:ChatData):void
        {
            var _local_2:String = "";
            _local_2 = (_local_2 + Helpers.deCodeString(_arg_1.htmlMessage));
            this._msg.htmlText = (("<a>" + _local_2) + "</a>");
        }

        private function initMsg():void
        {
            this._msg = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.downFightMsg.text");
            addChild(this._msg);
        }

        public function dispose():void
        {
            if (this._msg)
            {
                ObjectUtils.disposeObject(this._msg);
                this._msg = null;
            };
        }


    }
}//package SingleDungeon.expedition.msg

