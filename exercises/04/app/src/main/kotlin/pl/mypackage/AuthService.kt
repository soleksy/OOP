package pl.mypackage
import org.springframework.stereotype.Service

@Service
class AuthService {
    private val loginForm: LoginForm = LoginForm()


    fun login(login: String, password: String): Boolean{
        if (login.isNullOrEmpty() || password.isNullOrEmpty()) {
            return false
        }else if (login !=  loginForm.login || password != loginForm.password){
            return false
        }
        return  true
    }


}