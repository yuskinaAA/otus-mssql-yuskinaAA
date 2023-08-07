using System;
using System.Data.SqlTypes;
using System.IO;
using System.Text.RegularExpressions;
using Microsoft.SqlServer.Server;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

/*
SqlUserDefinedType:

* Format - обязательный, определяет метод 
* сериализации,
    UserDefined - IBinarySerialize, 
    Native - только для struct с "простыми" полями 

* IsByteOrdered - по умолчанию true

* IsFixedLength - по умолчанию false

* MaxByteSize - макс.размер, которого может достигать тип:
    -1 - неограничен (2ГБ, с SQL Server 2008)
    1  - 8000
*/

[Serializable]
[SqlUserDefinedType(
    Format.UserDefined,
    IsByteOrdered = true,
    IsFixedLength = false,
    MaxByteSize = -1)]

public class JsonCLR : INullable, IBinarySerialize
{
    // Поле для хранения значения
    private string _json;

    // Пользователи будут работать 
    // через свойство, здесь же валидация
    public SqlString Json
    {
        get
        {
            return new SqlString(_json);
        }

        set
        {
            if (value == SqlString.Null)
            {
                _json = string.Empty;

                return;
            }
            string str = (string)value;

            str = str.Trim();
            if ((str.StartsWith("{") && str.EndsWith("}")) || //For object
                (str.StartsWith("[") && str.EndsWith("]"))) //For array
            {
                try
                {
                    var obj = JToken.Parse(str);
                    _json = str;
                }
                catch (Exception ex) //some other exception
                {
                    throw new ArgumentException(ex.ToString());
                }
            }
            else
                throw new ArgumentException("Invalid json format");

        }

    }

    public bool IsNull
    {
        get { return string.IsNullOrEmpty(_json); }
    }

    public override string ToString()
    {
        return _json;
    }

    public static JsonCLR Null
    {
        // Это тот же Null,
        // что видели раньше во встроенных типах:
        // SqlString.Null, SqlInt32.Null
        get
        {
            JsonCLR js = new JsonCLR();
            js._json = string.Empty;

            return js;
        }
    }

    public static JsonCLR Parse(SqlString str)
    {
        if (str.IsNull)
            return JsonCLR.Null;

        var js = new JsonCLR();
        js.Json = str.ToString();

        return js;
    }

    public void Read(BinaryReader r)
    {
        _json = r.ReadString();
    }

    public void Write(BinaryWriter w)
    {
        w.Write(_json);
    }
}