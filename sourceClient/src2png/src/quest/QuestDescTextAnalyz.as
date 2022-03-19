// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestDescTextAnalyz

package quest
{
    public class QuestDescTextAnalyz 
    {


        public static function start(_arg_1:String):String
        {
            var _local_2:String = _arg_1;
            var _local_3:Array = new Array(/cr>|cg>|cb>/gi, /<cr/gi, /<cg/gi, /<cb/gi, /【/gi, /】/gi);
            var _local_4:Array = new Array("</font><font>", "</font><font COLOR='#FF0000'>", "</font><font COLOR='#00FF00'>", "</font><font COLOR='#0000FF'>", "</font><a href='http://blog.163.com/redirect.html'><font COLOR='#00FF00'><u>", "</u></font></a><font>");
            var _local_5:int;
            while (_local_5 < _local_3.length)
            {
                _local_2 = _local_2.replace(_local_3[_local_5], _local_4[_local_5]);
                _local_5++;
            };
            return (("<font>" + _local_2) + "</font>");
        }


    }
}//package quest

