import {
  createAsyncThunk,
  createSlice,
  type PayloadAction,
} from "@reduxjs/toolkit";
import * as authApi from "../../services/authApi";
import type {
  AuthState,
  LoginFormData,
  SignupFormData,
  verifyOtpResponse,
} from "../../types/auth";

const initialState: AuthState = {
  form: {
    displayName: "",
    username: "",
    email: "",
    otp: "",
    otpVerified: false,
  },
  otpSent: false,
  loginForm: {
    email: "",
    otp: "",
  },
  loginOtpSent: false,
  loading: false,
  error: null,
  profile: null,
  isAuthenticated: false,
};

export const sendOtp = createAsyncThunk(
  "auth/sendOtp",
  async (email: string, { rejectWithValue }) => {
    try {
      await authApi.sendOtp(email);
      return email;
    } catch (err) {
      return rejectWithValue(
        err instanceof Error ? err.message : "Failed to send OTP",
      );
    }
  },
);

export const sendLoginOtp = createAsyncThunk(
  "auth/sendLoginOtp",
  async (email: string, { rejectWithValue }) => {
    try {
      await authApi.sendOtp(email);
      return email;
    } catch (err) {
      return rejectWithValue(
        err instanceof Error ? err.message : "Failed to send OTP",
      );
    }
  },
);

export const signup = createAsyncThunk(
  "auth/signup",
  async (data: SignupFormData, { rejectWithValue }) => {
    try {
      const response = await authApi.signup(data);
      return response.profile ?? null;
    } catch (err) {
      return rejectWithValue(
        err instanceof Error ? err.message : "Failed to create account",
      );
    }
  },
);

export const login = createAsyncThunk(
  "auth/login",
  async (data: LoginFormData, { rejectWithValue }) => {
    try {
      const response = await authApi.login(data);
      return response.profile ?? null;
    } catch (err) {
      return rejectWithValue(
        err instanceof Error ? err.message : "Failed to log in",
      );
    }
  },
);

export const verifyOtp = createAsyncThunk<
  verifyOtpResponse,
  { email: string; otp: string },
  { rejectValue: verifyOtpResponse }
>(
  "auth/verifyOtp",
  async (data, { rejectWithValue }) => {
    try {
      const response = await authApi.verifyOtp(data.email, data.otp);
      return {
        success: response.success ?? false,
        message: response.message!,
      };
    } catch (err) {
      return rejectWithValue({
        success: false,
        message: err instanceof Error ? err.message : "Failed to verify OTP",
      });
    }
  },
);

type SignupTextField = Exclude<keyof SignupFormData, "otpVerified">;

const authSlice = createSlice({
  name: "auth",
  initialState,
  reducers: {
    updateFormField(
      state,
      action: PayloadAction<{ field: SignupTextField; value: string }>,
    ) {
      state.form[action.payload.field] = action.payload.value;
      state.error = null;
    },
    setOtpVerified(state, action: PayloadAction<boolean>) {
      state.form.otpVerified = action.payload;
      if (action.payload) {
        state.error = null;
      }
    },
    setError(state, action: PayloadAction<string>) {
      state.error = action.payload;
    },
    updateLoginField(
      state,
      action: PayloadAction<{ field: keyof LoginFormData; value: string }>,
    ) {
      state.loginForm[action.payload.field] = action.payload.value;
      state.error = null;
    },
    resetAuthError(state) {
      state.error = null;
    },
    resetAuthForm(state) {
      state.form = initialState.form;
      state.otpSent = false;
      state.error = null;
    },
    resetLoginForm(state) {
      state.loginForm = initialState.loginForm;
      state.loginOtpSent = false;
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(sendOtp.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(sendOtp.fulfilled, (state) => {
        state.loading = false;
        state.otpSent = true;
      })
      .addCase(sendOtp.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload as string;
      })
      .addCase(sendLoginOtp.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(sendLoginOtp.fulfilled, (state) => {
        state.loading = false;
        state.loginOtpSent = true;
      })
      .addCase(sendLoginOtp.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload as string;
      })
      .addCase(signup.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(signup.fulfilled, (state, action) => {
        state.loading = false;
        state.profile = action.payload;
        state.isAuthenticated = true;
      })
      .addCase(signup.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload as string;
      })
      .addCase(login.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(login.fulfilled, (state, action) => {
        state.loading = false;
        state.profile = action.payload;
        state.isAuthenticated = true;
      })
      .addCase(login.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload as string;
      })
      .addCase(verifyOtp.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(verifyOtp.fulfilled, (state, action) => {
        state.loading = false;
        state.form.otpVerified = action.payload.success;
        if (!action.payload.success) {
          state.error = action.payload.message;
        }
      })
      .addCase(verifyOtp.rejected, (state, action) => {
        state.loading = false;
        state.form.otpVerified = false;
        state.error = action.payload?.message ?? "Failed to verify OTP";
      });
  },
});

export const {
  updateFormField,
  updateLoginField,
  resetAuthError,
  resetAuthForm,
  resetLoginForm,
  setOtpVerified,
  setError,
} = authSlice.actions;
export default authSlice.reducer;
